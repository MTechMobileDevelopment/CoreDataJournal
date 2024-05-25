//
//  AddEditJournalView.swift
//  CoreDataJournal
//
//  Created by Parker Rushton on 5/13/24.
//

import SwiftUI

struct AddEditJournalView: View {

    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss

    @State private var title = ""
    @State private var selectedColor = Color.blue

    private var saveIsDisabled: Bool {
        title.isEmpty
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                TextField("New Journal Name", text: $title)
                    .textFieldStyle(.roundedBorder)

                Spacer()

                ColorPicker("Set Journal Color", selection: $selectedColor, supportsOpacity: false)

                Spacer()

                Button(action: save) {
                    Text("Save")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(Color.blue)
                        )
                }
                .foregroundStyle(Color.white)
                .contentShape(Rectangle())
                .opacity(saveIsDisabled ? 0.5 : 1)
                .disabled(saveIsDisabled)
            }
            .padding()
            .navigationTitle("New Journal")
        }
    }

    func save() {
        let newJournal = Journal(title: title, colorHex: selectedColor.toHexString())
        context.insert(newJournal)
        dismiss()
    }

}

#Preview {
    AddEditJournalView()
}
