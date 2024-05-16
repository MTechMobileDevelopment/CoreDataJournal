//
//  ContentView.swift
//  CoreDataJournal
//
//  Created by Parker Rushton on 5/8/24.
//

import SwiftUI
import CoreData

var relativeDateFormatter: RelativeDateTimeFormatter = {
    let formatter = RelativeDateTimeFormatter()
    formatter.dateTimeStyle = .numeric
    return formatter
}()

struct EntriesView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var journal: Journal

    @State private var isShowingNewEntryView = false
    @State private var selectedEntry: Entry?


    var body: some View {
        VStack {
            List {
                ForEach(journal.entriesArray) { entry in
                    entryView(entry)
                        .onTapGesture {
                            self.selectedEntry = entry
                        }
                }
            }
        }
        .navigationTitle(journal.title)
        .toolbar {
            ToolbarItem {
                Button(action: showNewEntryView) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $isShowingNewEntryView) {
            AddEditEntryView(journal: journal)
        }
        .sheet(item: $selectedEntry) { entry in
            AddEditEntryView(journal: journal, entry: entry)
        }
    }

    func entryView(_ entry: Entry) -> some View  {
        HStack {
            if let imageData = entry.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 50)
            }

            VStack(alignment: .leading) {
                Text(entry.title)

                if let relativeString = relativeDateFormatter.string(for: entry.createdAt) {
                    Text(relativeString)
                }
            }

            Spacer()
        }
        .contentShape(Rectangle())
    }

}

extension EntriesView {

    func showNewEntryView() {
        isShowingNewEntryView = true
    }

}
