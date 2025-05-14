//
//  FlashCardsView.swift
//  PocketWords
//
//  Created by Ashkan Ghaderi on 2/24/1404 AP.
//

import SwiftUI
import SwiftData

struct FlashCardsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: FlashCardsViewModel

    init() {
        let tempContainer = try! ModelContainer(
            for: WordCard.self,
            UserProgress.self,
            configurations: .init(isStoredInMemoryOnly: true)
        )
        _viewModel = State(
            initialValue: FlashCardsViewModel(
                modelContext: tempContainer.mainContext
            )
        )
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.cards.isEmpty {
                    emptyStateView
                } else {
                    contentView
                }
            }
            .navigationTitle("PocketWords")
            .toolbar { addCardButton }
            .sheet(isPresented: $viewModel.showAddCard) {
                AddCardView(viewModel: viewModel)
            }
        }
        .onAppear {
            if viewModel.modelContext != modelContext {
                viewModel = FlashCardsViewModel(modelContext: modelContext)
            }
        }
    }

    // MARK: - Subviews

    private var emptyStateView: some View {
        ContentUnavailableView(
            "No Cards Available",
            systemImage: "rectangle.stack.fill",
            description: Text("Add your first vocabulary card to get started")
        )
    }

    private var contentView: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("XP Progress: \(viewModel.userProgress.totalXP) XP")
                        .font(.subheadline)

                    ProgressView(value: viewModel.progressValue, total: 1.0)
                        .progressViewStyle(LinearProgressViewStyle())
                        .tint(.blue)
                }
                .padding(.horizontal)

                if let card = viewModel.currentCard {
                    CardView(card: card)

                    VStack(spacing: 8) {
                        TextField("Type the meaning", text: $viewModel.userAnswer)
                            .textFieldStyle(.roundedBorder)
                            .onSubmit(viewModel.checkAnswer)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(viewModel.answerBorderColor, lineWidth: 2)
                            )
                            .padding(.horizontal)
                            .animation(.easeInOut, value: viewModel.answerBorderColor)


                        if let isCorrect = viewModel.isAnswerCorrect {
                            HStack(spacing: 4) {
                                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                Text(isCorrect ? "Correct! +10 XP" : "Incorrect - Try again")
                            }
                            .foregroundColor(isCorrect ? .green : .red)
                            .transition(.scale.combined(with: .opacity))
                        }
                    }

                    Button("Next Card", action: viewModel.nextCard)
                        .buttonStyle(.borderedProminent)
                }

                Spacer()
            }
            .padding(.top)
        }
    }

    private var addCardButton: some View {
        Button(action: { viewModel.showAddCard = true }) {
            Image(systemName: "plus")
                .accessibilityLabel("Add new card")
        }
    }
}
