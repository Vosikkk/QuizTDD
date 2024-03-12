//
//  QuizTests.swift
//  QuizEngineTests
//
//  Created by Саша Восколович on 13.03.2024.
//

import XCTest
@testable import QuizEngine


final class QuizTests: XCTestCase {
   
    private var quiz: Game<String, String, DelegateSpy>!
    private let delegate = DelegateSpy()
    
    override func setUp() {
        super.setUp()
        quiz = startGame(questions: ["Q1", "Q2"], router: delegate, correctAnswers: ["Q1": "A1", "Q2": "A2"])
    }
    
    override func tearDown() {
        quiz = nil
        super.tearDown()
    }
    
    func test_startQuiz_answerZeroOutOfTwoCorrectly_scoresZero() {
        delegate.answerCallback("wrong")
        delegate.answerCallback("wrong")
        
        XCTAssertEqual(delegate.handledResult!.score, 0)
    }
    
    
    func test_startQuiz_answerOneOutOfTwoCorrectly_scoresOne() {
        delegate.answerCallback("A1")
        delegate.answerCallback("wrong")
        
        XCTAssertEqual(delegate.handledResult!.score, 1)
    }
    
    
    func test_startQuiz_answerTwoOutOfTwoCorrectly_scoresTwo() {
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        
        XCTAssertEqual(delegate.handledResult!.score, 2)
    }
    
    private class DelegateSpy: Router {
        
        var answerCallback: (String) -> Void = { _ in }
        var handledResult: Result<String, String>? = nil
        
        func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
            self.answerCallback = answerCallback
        }
        
        func routeTo(result: Result<String, String>) {
            handledResult = result
        }
    }
}
