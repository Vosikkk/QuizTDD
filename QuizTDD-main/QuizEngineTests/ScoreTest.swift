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
    
    private class BasicScore {
        static func score(for: [Any], comparingTo: [Any]) -> Int {
            0
        }
    }
}
