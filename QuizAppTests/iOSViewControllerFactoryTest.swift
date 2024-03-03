//
//  iOSViewControllerFactoryTest.swift
//  QuizAppTests
//
//  Created by Саша Восколович on 03.03.2024.
//

import XCTest
@testable import QuizApp

final class iOSViewControllerFactoryTest: XCTestCase {

    func test_questionViewController_createsViewControllerWithQuestion() {
        
        let question = Question.singleAnswer("Q1")
        let options = ["A1", "A2"]
        let sut = iOSViewControllerFactory(options: [question: options])
        
        let controller = sut.questionViewController(for: Question.singleAnswer("Q1"), answerCallback: { _ in }) as? QuestionViewController
        
        XCTAssertEqual(controller?.question, "Q1")
    }
    
    func test_questionViewController_createsViewControllerWithOptions() {
        let question = Question.singleAnswer("Q1")
        let options = ["A1", "A2"]
        let sut = iOSViewControllerFactory(options: [question: options])
        
        let controller = sut.questionViewController(for: question, answerCallback: { _ in }) as? QuestionViewController
        
        XCTAssertEqual(controller?.options, options)
    }


}
