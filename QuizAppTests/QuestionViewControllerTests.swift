//
//  QuestionViewControllerTests.swift
//  QuizAppTests
//
//  Created by Саша Восколович on 25.02.2024.
//
import Foundation
import XCTest
@testable import QuizApp

final class QuestionViewControllerTests: XCTestCase {

    func test_viewDidLoad_rendersQuestionHeaderText() {
        XCTAssertEqual(makeSUT(question: "Q1").headerLabel.text, "Q1")
    }
    
    func test_viewDidLoad_renedersOptions() {
        
        let sut0 = makeSUT(options: [])
        XCTAssertEqual(sut0.tableView.numberOfRows(inSection: 0), 0)
        
        let sut1 = makeSUT(options: ["A1"])
        XCTAssertEqual(sut1.tableView.numberOfRows(inSection: 0), 1)
        
        let sut2 = makeSUT(options: ["A1", "A2"])
        XCTAssertEqual(sut2.tableView.numberOfRows(inSection: 0), 2)
    }
    
    func test_viewDidLoad__renedersOptionsText() {
        let sut = makeSUT(options: ["A1", "A2"])
        XCTAssertEqual(sut.tableView.title(at: 0), "A1")
        XCTAssertEqual(sut.tableView.title(at: 1), "A2")
    }
    
    func test_optionSelected_notifiesDelegate() {
        
        var receivedAnswer = ""
        let sut = makeSUT(options: ["A1"]) {
            receivedAnswer = $0
        }
        let indexPath = IndexPath(row: 0, section: 0)
        sut.tableView.delegate?.tableView?(sut.tableView, didSelectRowAt: indexPath)
        
        XCTAssertEqual(receivedAnswer, "A1")
    }

    func makeSUT(question: String = "",
                 options: [String] = [],
                 selection: @escaping (String) -> Void = { _ in }) -> QuestionViewController {
        let sut = QuestionViewController(question: question, options: options, selection: selection)
        sut.loadViewIfNeeded()
        return sut
    }
}





private extension UITableViewCell {
    var textFromContext: String? {
        (self.contentConfiguration as? UIListContentConfiguration)?.text
    }
}

private extension UITableView {
    
    func cell(at row: Int) -> UITableViewCell? {
    dataSource?.tableView(self, cellForRowAt: IndexPath(row: row, section: 0))
    }
    
    func title(at row: Int) -> String? {
        if #available(iOS 14, *) {
            cell(at: row)?.textFromContext
        } else {
            cell(at: row)?.textLabel?.text
        }
    }
}
