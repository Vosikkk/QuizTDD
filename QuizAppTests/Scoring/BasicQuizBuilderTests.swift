//
//  BasicQuizBuilderTests.swift
//  QuizAppTests
//
//  Created by Саша Восколович on 05.04.2024.
//

import XCTest

struct BasicQuiz {}

struct BasicQuizBuilder {
    func build() -> BasicQuiz? {
        nil
    }
}

final class BasicQuizBuilderTests: XCTestCase {

    
    func test_empty() {
        let sut = BasicQuizBuilder()
        
        XCTAssertNil(sut.build())
    }
   
}
    
