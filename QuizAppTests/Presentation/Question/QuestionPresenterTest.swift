//
//  QuestionPresenterTest.swift
//  QuizAppTests
//
//  Created by Саша Восколович on 04.03.2024.
//

import XCTest
import QuizEngine
@testable import QuizApp

final class QuestionPresenterTest: XCTestCase {
    
    let question1 = Question.singleAnswer("A1")
    let question2 = Question.multipleAnswer("A2")
    
    
    func test_title_forFirstQuestion_formatsTitleForIndex() {
        let sut = QuestionPresenter(questions: [question1, question2], question: question1)
        XCTAssertEqual(sut.title, "1 of 2")
    }
    
    
    func test_title_forSecondQuestion_formatsTitleForIndex() {
        let sut = QuestionPresenter(questions: [question1, question2], question: question2)
        XCTAssertEqual(sut.title, "2 of 2")
    }
    
    
    func test_title_forUnexistentQuestion_isEmpty() {
        let sut = QuestionPresenter(questions: [], question: question1)
        XCTAssertEqual(sut.title, "")
    }
}
