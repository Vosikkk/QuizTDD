//
//  FlowTests.swift
//  QuizEngineTests
//
//  Created by Саша Восколович on 24.02.2024.
//

import XCTest
@testable import QuizEngine

final class FlowTests: XCTestCase {
    
    
    func test_start_withNoQuestions_doesNotDelegateQuestionHandling() {
        makeSUT(questions: []).start()
        XCTAssertEqual(delegate.questionAsked.isEmpty, true)
    }

    func test_start_withOneQuestion_delegatesCorrectQuestionHandling() {
        makeSUT(questions: ["Q1"]).start()
        XCTAssertEqual(delegate.questionAsked, ["Q1"])
    }
    
    
    func test_start_withOneQuestion_delegatesAnotherCorrectQuestionHandling() {
        makeSUT(questions: ["Q2"]).start()
        XCTAssertEqual(delegate.questionAsked, ["Q2"])
    }
    
    
    func test_start_withTwoQuestions_delegatesFirstQuestionHandling() {
        makeSUT(questions: ["Q1", "Q2"]).start()
        XCTAssertEqual(delegate.questionAsked, ["Q1"])
    }
    
    func test_startTwice_withTwoQuestions_delegatesFirstQuestionHandlingTwice() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        sut.start()
        XCTAssertEqual(delegate.questionAsked, ["Q1", "Q1"])
    }
   
    func test_start_withOneQuestion_doesNotCompleteQuiz() {
        makeSUT(questions: ["Q1"]).start()
        XCTAssertTrue(delegate.completedQuizzes.isEmpty)
    }
    
    func test_start_withNoQuestions_completeWithEmptyQuiz() {
        makeSUT(questions: []).start()
        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        XCTAssertTrue(delegate.completedQuizzes[0].isEmpty)
    }
    
    
    func test_startAndAnswerFirstQuestion_withOneQuestion_doesNotDelegateAnotherQuestionHandling() {
        let sut = makeSUT(questions: ["Q1"])
        sut.start()
        delegate.answerCompletions[0]("A1")
        XCTAssertEqual(delegate.questionAsked, ["Q1"])
    }
    
    
    func test_startAndAnswerFirstQuestion_withTwoQuestions_doesNotCompleteQuiz() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        delegate.answerCompletions[0]("A1")
        XCTAssertTrue(delegate.completedQuizzes.isEmpty)
    }
    
    
    func test_startAndAnswerFirstAndSecondQuestions_withThreeQuestions_delegatesSecondAndThirdQuestionHandling() {
        let sut = makeSUT(questions: ["Q1", "Q2", "Q3"])
        sut.start()
        delegate.answerCompletions[0]("A1")
        delegate.answerCompletions[1]("A2")
        XCTAssertEqual(delegate.questionAsked, ["Q1", "Q2", "Q3"])
    }
    
    func test_startAndAnswerFirstAndSecondQuestions_withTwoQuestions_completesQuiz() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        delegate.answerCompletions[0]("A1")
        delegate.answerCompletions[1]("A2")
        
        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        
        assertEqual(delegate.completedQuizzes[0], [("Q1", "A1"), ("Q2", "A2")])
    }
    
    func test_startAndAnswerFirstAndSecondQuestionsTwice_withTwoQuestions_completesQuizTwice() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        delegate.answerCompletions[0]("A1")
        delegate.answerCompletions[1]("A2")
        
        
        delegate.answerCompletions[0]("A1-1")
        delegate.answerCompletions[1]("A2-2")
        XCTAssertEqual(delegate.completedQuizzes.count, 2)
        
        assertEqual(delegate.completedQuizzes[0], [("Q1", "A1"), ("Q2", "A2")])
        
        assertEqual(delegate.completedQuizzes[1], [("Q1", "A1-1"), ("Q2", "A2-2")])
    }
    
    
    // MARK: - Helper
    
    private weak var weakSUT: Flow<DelegateSpy>?
    
    private let delegate = DelegateSpy()
    
    override func tearDown() {
        super.tearDown()
        
        XCTAssertNil(weakSUT, "Memory leak detected. Weak reference to the SUT instance is not Nil")
    }
    
    private func makeSUT(questions: [String]) -> Flow<DelegateSpy> {
        let sut = Flow(questions: questions, delegate: delegate)
        weakSUT = sut
        return sut
    }
}
