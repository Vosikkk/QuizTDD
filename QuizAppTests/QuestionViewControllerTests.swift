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
    

    func test_optionSelected_withSingleSelection_notifiesDelegateWithLastSelection() {
        var receivedAnswer: [String] = []
        let sut = makeSUT(options: ["A1", "A2"]) { receivedAnswer = $0 }
        
        sut.tableView.select(row: 0)
        XCTAssertEqual(receivedAnswer, ["A1"])
        
        sut.tableView.select(row: 1)
        XCTAssertEqual(receivedAnswer, ["A2"])
    }
    
    
    func test_optionDeselected_withSingleSelection_doesNotNotifyDelegateWithEmptySelection() {
        var callBackCount = 0
        let sut = makeSUT(options: ["A1", "A2"]) { _ in callBackCount += 1 }
        
        sut.tableView.select(row: 0)
        XCTAssertEqual(callBackCount, 1)
        
        sut.tableView.deselect(row: 0)
        XCTAssertEqual(callBackCount, 1)
    }
    
    func test_optionSelected_withMultipleSelectionEnabled_notifiesDelegateSelection() {
        var receivedAnswer: [String] = []
        
        let sut = makeSUT(options: ["A1", "A2"]) { receivedAnswer = $0 }
        sut.tableView.allowsMultipleSelection = true
        sut.tableView.select(row: 0)
        XCTAssertEqual(receivedAnswer, ["A1"])
        
        sut.tableView.select(row: 1)
        XCTAssertEqual(receivedAnswer, ["A1", "A2"])
    }
    
    
    func test_optionDeselected_withMultipleSelectionEnabled_notifiesDelegate() {
        var receivedAnswer: [String] = []
        
        let sut = makeSUT(options: ["A1", "A2"]) { receivedAnswer = $0 }
        sut.tableView.allowsMultipleSelection = true
        sut.tableView.select(row: 0)
        XCTAssertEqual(receivedAnswer, ["A1"])
        
        sut.tableView.deselect(row: 0)
        XCTAssertEqual(receivedAnswer, [])
    }
    
    
    
    // MARK: - Helpers
    func makeSUT(question: String = "",
                 options: [String] = [],
                 selection: @escaping ([String]) -> Void = { _ in }) -> QuestionViewController {
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
    
    func select(row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        selectRow(at: indexPath, animated: false, scrollPosition: .none)
        delegate?.tableView?(self, didSelectRowAt: indexPath)
    }
    
    func deselect(row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        deselectRow(at: indexPath, animated: false)
        delegate?.tableView?(self, didDeselectRowAt: indexPath)
    }
}
