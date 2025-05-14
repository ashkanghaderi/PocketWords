//
//  FlashCardsViewModelTests.swift
//  PocketWordsTests
//
//  Created by Ashkan Ghaderi on 2/24/1404 AP.
//

import XCTest
@testable import PocketWords
import SwiftData

final class FlashCardsViewModelTests: XCTestCase {
    var container: ModelContainer!
    var context: ModelContext!
    var viewModel: FlashCardsViewModel!

    override func setUp() {
        super.setUp()
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try! ModelContainer(for: WordCard.self, UserProgress.self, configurations: config)
        context = ModelContext(container)

        // Insert test data
        let card1 = WordCard(word: "Apple", meaning: "A fruit")
        let card2 = WordCard(word: "Car", meaning: "A vehicle")
        context.insert(card1)
        context.insert(card2)

        viewModel = FlashCardsViewModel(modelContext: context)
    }

    override func tearDown() {
        container = nil
        context = nil
        viewModel = nil
        super.tearDown()
    }

    // MARK: - Initial State Tests

    func testInitialState() {
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.cards.count, 2)
        XCTAssertEqual(viewModel.currentCardIndex, 0)
        XCTAssertEqual(viewModel.userAnswer, "")
        XCTAssertNil(viewModel.isAnswerCorrect)
        XCTAssertFalse(viewModel.showAddCard)
    }

    // MARK: - Answer Checking Tests

    func testCorrectAnswer() throws {
        let initialXP = viewModel.userProgress.totalXP
        viewModel.userAnswer = "A fruit"
        viewModel.checkAnswer()

        XCTAssertTrue(viewModel.isAnswerCorrect ?? false)
        XCTAssertEqual(viewModel.userProgress.totalXP, initialXP + 10)
        XCTAssertEqual(viewModel.userAnswer, "")
        XCTAssertEqual(viewModel.answerBorderColor, .green)
    }

    func testIncorrectAnswer() throws {
        let initialXP = viewModel.userProgress.totalXP
        viewModel.userAnswer = "Wrong answer"
        viewModel.checkAnswer()

        XCTAssertFalse(viewModel.isAnswerCorrect ?? true)
        XCTAssertEqual(viewModel.userProgress.totalXP, initialXP)
        XCTAssertEqual(viewModel.userAnswer, "")
        XCTAssertEqual(viewModel.answerBorderColor, .red)
    }

    func testCaseInsensitiveAnswer() throws {
        viewModel.userAnswer = "  A FRUIT  " // With whitespace and uppercase
        viewModel.checkAnswer()

        XCTAssertTrue(viewModel.isAnswerCorrect ?? false)
    }

    // MARK: - Card Navigation Tests

    func testNextCard() throws {
        let initialIndex = viewModel.currentCardIndex
        viewModel.nextCard()

        XCTAssertEqual(viewModel.currentCardIndex, initialIndex + 1)
        XCTAssertNil(viewModel.isAnswerCorrect)
    }

    func testNextCardWrapsAround() throws {
        viewModel.currentCardIndex = viewModel.cards.count - 1
        viewModel.nextCard()

        XCTAssertEqual(viewModel.currentCardIndex, 0)
    }

    // MARK: - XP Progress Tests

    func testProgressCalculation() throws {
        // 2 cards = max 20 XP possible
        viewModel.userAnswer = "A fruit"
        viewModel.checkAnswer()

        XCTAssertEqual(viewModel.progressValue, 0.5)

        viewModel.nextCard()
        viewModel.userAnswer = "A vehicle"
        viewModel.checkAnswer()

        XCTAssertEqual(viewModel.progressValue, 1.0)
    }

    func testProgressWithNoCards() throws {
        let emptyContainer = try! ModelContainer(for: WordCard.self, UserProgress.self,
                                              configurations: .init(isStoredInMemoryOnly: true))
        let emptyContext = ModelContext(emptyContainer)
        let emptyViewModel = FlashCardsViewModel(modelContext: emptyContext)

        XCTAssertEqual(emptyViewModel.progressValue, 0.0)
    }

    // MARK: - Add Card Tests

    func testAddCard() throws {
        let initialCount = viewModel.cards.count
        try viewModel.addCard(word: "Book", meaning: "For reading")

        XCTAssertEqual(viewModel.cards.count, initialCount + 1)
        XCTAssertEqual(viewModel.cards.last?.word, "Book")
        XCTAssertEqual(viewModel.cards.last?.meaning, "For reading")
    }

    func testAddCardPersistence() throws {
        try viewModel.addCard(word: "Test", meaning: "Test")

        let descriptor = FetchDescriptor<WordCard>()
        let count = try context.fetchCount(descriptor)
        XCTAssertEqual(count, 3) 
    }
}
