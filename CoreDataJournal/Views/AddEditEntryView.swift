//
//  AddEditEntryView.swift
//  CoreDataJournal
//
//  Created by Parker Rushton on 5/9/24.
//

import SwiftUI

struct AddEditEntryView: View {

    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss

    var journal: Journal
    var entry: Entry?

    @State private var title = ""
    @State private var bodyString = ""
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage?

    private var saveIsDisabled: Bool {
        title.isEmpty || bodyString.isEmpty
    }


    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                HStack {
                    TextField("Title", text: $title)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: .infinity, minHeight: 44)

                    imageButton()
                        .fixedSize()
                }

                TextEditor(text: $bodyString)
                    .textEditorStyle(.plain)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )

                Spacer()

                Button(action: save) {
                    Text("Save")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Color.white)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(Color.blue)
                        )
                }
                .contentShape(Rectangle())
                .opacity(saveIsDisabled ? 0.5 : 1)
                .disabled(saveIsDisabled)
            }
            .padding()
            .navigationTitle(entry == nil ? "New Entry" : entry!.title)
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(image: $selectedImage)
            }
        }
        .onAppear {
            if let entry {
                title = entry.title
                bodyString = entry.body
                if let imageData = entry.imageData {
                    selectedImage = UIImage(data: imageData)
                }
            }
        }
    }

    func imageButton() -> some View {
        Button {
            presentImagePicker()
        } label: {
            if let selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
            }
        }
    }

    func presentImagePicker() {
        isShowingImagePicker = true
    }

    func save() {
        if let entry {
            update(entry)
        } else {
            createNewEntry()
        }
        dismiss()
    }

    func update(_ entry: Entry) {
        entry.title = title
        entry.body = bodyString
        entry.imageData = selectedImage?.jpegData(compressionQuality: 0.75)
        try? context.save()
    }

    func createNewEntry() {
        let imageData = selectedImage?.jpegData(compressionQuality: 0.75)
        let newEntry = Entry(journal: journal, title: title, body: bodyString, imageData: imageData)
        context.insert(newEntry)
        try? context.save()
    }

}
