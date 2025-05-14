//
//  AddCardView.swift
//  PocketWords
//
//  Created by Ashkan Ghaderi on 2/24/1404 AP.
//

import SwiftUI

struct AddCardView: View {
    @Bindable var viewModel: FlashCardsViewModel
    @State private var word = ""
    @State private var meaning = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Word", text: $word)
                    TextField("Meaning", text: $meaning)
                }
            }
            .navigationTitle("Add New Card")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        viewModel.showAddCard = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        try? viewModel.addCard(word: word, meaning: meaning)
                        viewModel.showAddCard = false
                    }
                    .disabled(word.isEmpty || meaning.isEmpty)
                }
            }
        }
    }
}
