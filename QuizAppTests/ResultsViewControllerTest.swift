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
        
        let sut1 = makeSUT(answers: [makeDummyAnswer()])
        XCTAssertEqual(sut1.tableView.numberOfRows(inSection: 0), 1)
    }
    
    func test_viewDidLoad_withCorrectAnswer_renderCorrectAnswerCell() {
        let sut = makeSUT(answers: [PresentableAnswer(isCorrect: true)])
        let cell = sut.tableView.cell(at: 0) as? CorrectAnswerCell
        XCTAssertNotNil(cell)
    }
    
    func test_viewDidLoad_withWrongAnswer_renderWrongAnswerrCell() {
        let sut = makeSUT(answers: [PresentableAnswer(isCorrect: false)])
        let cell = sut.tableView.cell(at: 0) as? WrongAnswerCell
        XCTAssertNotNil(cell)
    }
    
    
    // MARK: - Helpers

    func makeSUT(summary: String = "", answers: [PresentableAnswer] = []) -> ResultsViewController {
        let sut = ResultsViewController(summary: summary, answers: answers)
        sut.loadViewIfNeeded()
        return sut
    }
    
    func makeDummyAnswer() -> PresentableAnswer {
        PresentableAnswer(isCorrect: false)
    }
}
