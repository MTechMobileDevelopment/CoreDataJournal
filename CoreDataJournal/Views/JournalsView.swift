//
//  JournalsView.swift
//  CoreDataJournal
//
//  Created by Parker Rushton on 5/13/24.
//

import SwiftUI
import SwiftData

struct JournalsView: View {

    @Query(sort: \Journal.createdAt, order: .reverse) var journals: [Journal]

    @State private var isShowingNewJournalView = false

    var body: some View {
        NavigationStack {
            VStack {
                List(journals) { journal in
                    NavigationLink(destination: EntriesView(journal: journal)) {
                        journalView(journal)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Journals")
            .toolbar {
                ToolbarItem {
                    Button(action: showNewJournalView) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingNewJournalView) {
            AddEditJournalView()
        }
    }

    func journalView(_ journal: Journal) -> some View {
        HStack {
            if let hex = journal.colorHex, let color = Color(hex: hex) {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(color)
                    .frame(width: 40, height: 40)
            }
            VStack(alignment: .leading) {
                Text(journal.title)
                    .bold()

                Text("Entries: \(journal.entries.count)")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }
        }
    }

    func showNewJournalView() {
        isShowingNewJournalView = true
    }

}

#Preview {
    JournalsView()
}
