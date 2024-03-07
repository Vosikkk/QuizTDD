//
//  ResultsViewControllerTest.swift
//  QuizAppTests
//
//  Created by Саша Восколович on 25.02.2024.
//

import XCTest
@testable import QuizApp

final class ResultsViewControllerTest: XCTestCase {

    func test_viewDidLoad_renderSummary() {
        XCTAssertEqual(makeSUT(summary: "a summary").headerLabel.text, "a summary")
    }
    
    func test_viewDidLoad_rendersAnswers() {
        let sut0 = makeSUT(answers: [])
        XCTAssertEqual(sut0.tableView.numberOfRows(inSection: 0), 0)
        
        let sut1 = makeSUT(answers: [makeAnswer()])
        XCTAssertEqual(sut1.tableView.numberOfRows(inSection: 0), 1)
    }
    
    
    func test_viewDidLoad_withCorrectAnswer_configureCell() {
        let answer = makeAnswer(question: "Q1", answer: "A1")
        let sut = makeSUT(answers: [answer])
        let cell = sut.tableView.cell(at: 0) as? CorrectAnswerCell
        
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.questionLabel.text, "Q1")
        XCTAssertEqual(cell?.answerLabel.text, "A1")
    }
    
    
    func test_viewDidLoad_withWrongAnswer_configureCell() {
        let answer = makeAnswer(question: "Q1", answer: "A1", wrongAnswer: "Wrong")
        let sut = makeSUT(answers: [answer])
        let cell = sut.tableView.cell(at: 0) as? WrongAnswerCell
        
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.questionLabel.text, "Q1")
        XCTAssertEqual(cell?.correctAnswerLabel.text, "A1")
        XCTAssertEqual(cell?.wrongAnswerLabel.text, "Wrong")
    }
    
    
    // MARK: - Helpers

    func makeSUT(summary: String = "", answers: [PresentableAnswer] = []) -> ResultsViewController {
        let sut = ResultsViewController(summary: summary, answers: answers)
        sut.loadViewIfNeeded()
        return sut
    }
    
    func makeAnswer(question: String = "", answer: String = "", wrongAnswer: String? = nil) -> PresentableAnswer {
        PresentableAnswer(question: question, answer: answer, wrongAnswer: wrongAnswer)
    }
}
