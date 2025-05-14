//
//  FlashCardsViewModel.swift
//  PocketWords
//
//  Created by Ashkan Ghaderi on 2/24/1404 AP.
//

import SwiftData
import SwiftUI
import Observation

@Observable
final class FlashCardsViewModel {

    let modelContext: ModelContext
    private(set) var cards: [WordCard] = []
    private(set) var userProgress: UserProgress
    var currentCardIndex = 0
    private(set) var isAnswerCorrect: Bool?
    var userAnswer = ""
    var showAddCard = false
    var isLoading = true

    var answerBorderColor: Color {
        guard let isCorrect = isAnswerCorrect else { return .clear }
        return isCorrect ? .green : .red
    }

    var progressValue: Double {
        let totalPossibleXP = cards.count * 10
        guard totalPossibleXP > 0 else { return 0 }
        let calculatedProgress = Double(userProgress.totalXP) / Double(totalPossibleXP)
        return max(0, min(calculatedProgress, 1.0))
    }

    // MARK: - Initialization
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.userProgress = UserProgress()
        setupInitialData()
    }

    // MARK: - Public Methods
    func addCard(word: String, meaning: String) throws {
        let newCard = WordCard(word: word, meaning: meaning)
        modelContext.insert(newCard)
        try modelContext.save()
        cards.append(newCard)
    }

    func checkAnswer() {
        guard currentCardIndex < cards.count else { return }

        let correctAnswer = cards[currentCardIndex].meaning
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        let userAttempt = userAnswer
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        isAnswerCorrect = userAttempt == correctAnswer

        if isAnswerCorrect == true {
            userProgress.addXP(10)
            try? modelContext.save()
        }

        userAnswer = ""
    }

    func nextCard() {
        currentCardIndex = (currentCardIndex + 1) % cards.count
        isAnswerCorrect = nil
    }

    var currentCard: WordCard? {
        guard cards.indices.contains(currentCardIndex) else { return nil }
        return cards[currentCardIndex]
    }

    // MARK: - Private Methods
    private func setupInitialData() {
        fetchCards()
        fetchUserProgress()
    }

    private func fetchCards() {
        isLoading = true
        defer { isLoading = false }

        do {
            let descriptor = FetchDescriptor<WordCard>(
                sortBy: [SortDescriptor(\.createdAt)]
            )
            cards = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch cards: \(error)")
        }
    }

    private func fetchUserProgress() {
        do {
            let descriptor = FetchDescriptor<UserProgress>()
            if let existing = try modelContext.fetch(descriptor).first {
                userProgress = existing
            } else {
                userProgress = UserProgress()
                modelContext.insert(userProgress)
                try modelContext.save()
            }
        } catch {
            print("Failed to fetch progress: \(error)")
            userProgress = UserProgress()
            modelContext.insert(userProgress)
        }
    }
}
