//
//  BasicQuizBuilderTests.swift
//  QuizAppTests
//
//  Created by Саша Восколович on 05.04.2024.
//

import XCTest
import QuizEngine

struct BasicQuiz {
    let questions: [Question<String>]
}

struct BasicQuizBuilder {
    
    private let questions: [Question<String>]
    
    init(singleAnswerQuestion: String) {
        questions = [.singleAnswer(singleAnswerQuestion)]
    }
    
    func build() -> BasicQuiz {
        BasicQuiz(questions: questions)
    }
}

final class BasicQuizBuilderTests: XCTestCase {

    
    func test_initWithSingleAnswerQuestion() {
        let sut = BasicQuizBuilder(singleAnswerQuestion: "q1")
        
        XCTAssertEqual(sut.build().questions, [.singleAnswer("q1")])
    }
   
}
    
