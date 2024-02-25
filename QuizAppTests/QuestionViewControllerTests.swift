//
//  QuestionViewControllerTests.swift
//  QuizAppTests
//
//  Created by Саша Восколович on 25.02.2024.
//

import XCTest
@testable import QuizApp

final class QuestionViewControllerTests: XCTestCase {

    func test_viewDidLoad_rendersQuestionHeaderText() {
        
        let sut = QuestionViewController(question: "Q1", options: [])
        _ = sut.view
        
        XCTAssertEqual(sut.headerLabel.text, "Q1")
    }
    
    func test_viewDidLoad_withNoOptions_renedersZeroOptions() {
        
        let sut = QuestionViewController(question: "Q1", options: [])
        _ = sut.view
        
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 0)
    }
    
    func test_viewDidLoad_withOneOption_renedersOneOption() {
        
        let sut = QuestionViewController(question: "Q1", options: ["A1"])
        _ = sut.view
        
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 1)
    }
    
    
    func test_viewDidLoad_withOneOption_renedersOneOptionText() {
        
        let sut = QuestionViewController(question: "Q1", options: ["A1"])
        _ = sut.view
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView.dataSource?.tableView(sut.tableView, cellForRowAt: indexPath)
        
        XCTAssertEqual(cell?.textFromContext, "A1")
    }

}


extension UITableViewCell {
    var textFromContext: String? {
        (self.contentConfiguration as? UIListContentConfiguration)?.text
    }
}
