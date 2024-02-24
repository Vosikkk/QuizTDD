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
        
        let sut = QuestionViewController(question: "Q1")
        _ = sut.view
        
        XCTAssertEqual(sut.headerLabel.text, "Q1")
    }

}
