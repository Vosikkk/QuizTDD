//
//  ScoreTest.swift
//  QuizEngine
//
//  Created by Саша Восколович on 17.03.2024.
//

import XCTest

final class ScoreTest: XCTestCase {

    func test_noAnswers_scoresZero() {
        XCTAssertEqual(BasicScore.score(for: [], comparingTo: []), 0)
    }

    func test_oneWrongAnswer_scoresZero() {
        XCTAssertEqual(BasicScore.score(for: ["wrong"], comparingTo: ["correct"]), 0)
    }
    
    func test_oneCorrectAnswer_scoresOne() {
        XCTAssertEqual(BasicScore.score(for: ["correct"], comparingTo: ["correct"]), 1)
    }
    
    func test_oneCorrectAnswerOneWrong_scoresOne() {
        
        let score = BasicScore.score(for: ["correct 1", "wrong"], comparingTo: ["correct 1", "correct 2"])
        XCTAssertEqual(score, 1)
    }
    
    func test_twoCorrectAnswers_scoresTwo() {
        
        let score = BasicScore.score(for: ["correct 1", "correct 2"], comparingTo: ["correct 1", "correct 2"])
        XCTAssertEqual(score, 2)
    }
    
    private class BasicScore {
       
        static func score(for answers: [String], comparingTo correctAnswers: [String]) -> Int {
            var score: Int = 0
            
            for (index, answer) in answers.enumerated() {
                score += answer == correctAnswers[index] ? 1 : 0
            }
            return score
        }
    }
}
