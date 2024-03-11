//
//  DeprecatedGameTests.swift
//  QuizEngineTests
//
//  Created by Саша Восколович on 26.02.2024.
//

import XCTest
@testable import QuizEngine


@available(*, deprecated)
final class DeprecatedGameTests: XCTestCase {
    
    private var game: Game<String, String, RouterSpy>!
    private let router = RouterSpy()
    
    override func setUp() {
        super.setUp()
        game = startGame(questions: ["Q1", "Q2"], router: router, correctAnswers: ["Q1": "A1", "Q2": "A2"])
    }
    
    override func tearDown() {
        game = nil
        super.tearDown()
    }
    
    func test_startGame_answerZeroOutOfTwoCorrectly_scoresZero() {
        router.answerCallback("wrong")
        router.answerCallback("wrong")
        
        XCTAssertEqual(router.routedResult!.score, 0)
    }
    
    
    func test_startGame_answerOneOutOfTwoCorrectly_scoresOne() {
        router.answerCallback("A1")
        router.answerCallback("wrong")
        
        XCTAssertEqual(router.routedResult!.score, 1)
    }
    
    
    func test_startGame_answerTwoOutOfTwoCorrectly_scoresTwo() {
        router.answerCallback("A1")
        router.answerCallback("A2")
        
        XCTAssertEqual(router.routedResult!.score, 2)
    }
    
    private class RouterSpy: Router {
        
        var answerCallback: (String) -> Void = { _ in }
        var routedResult: Result<String, String>? = nil
        
        func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
            self.answerCallback = answerCallback
        }
        
        func routeTo(result: Result<String, String>) {
            routedResult = result
        }
    }
}
