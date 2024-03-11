//
//  QuestionTest.swift
//  QuizEngine
//
//  Created by Саша Восколович on 11.03.2024.
//

import XCTest
@testable import QuizEngine

final class QuestionTest: XCTestCase {

   
    func test_hashValue_withSameWrappedValue_isDifferentForSingleAnswer() {
        let aValue = UUID()
        XCTAssertNotEqual(Question.singleAnswer(aValue), Question.multipleAnswer(aValue))
    }
    
    func test_hashValue_forSingleAnswer() {
        let aValue = UUID()
        let anotherValue = UUID()
        
        XCTAssertEqual(Question.singleAnswer(aValue), Question.singleAnswer(aValue))
        XCTAssertNotEqual(Question.singleAnswer(aValue), Question.singleAnswer(anotherValue))
    }
    

    func test_hashValue_forMultipleAnswer() {
        let aValue = UUID()
        let anotherValue = UUID()
        
        XCTAssertEqual(Question.multipleAnswer(aValue), Question.multipleAnswer(aValue))
        XCTAssertNotEqual(Question.multipleAnswer(aValue), Question.multipleAnswer(anotherValue))
    }
}
