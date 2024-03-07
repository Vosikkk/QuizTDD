//
//  ResultHelper.swift
//  QuizAppTests
//
//  Created by Саша Восколович on 03.03.2024.
//

@testable import QuizEngine

extension Result: Hashable {
    public static func == (lhs: Result<Question, Answer>, rhs: Result<Question, Answer>) -> Bool {
        return lhs.score == rhs.score
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(1)
    }
    
    static func make(answers: [Question: Answer] = [:], score: Int = 0) -> Result<Question, Answer> {
         Result(answers: answers, score: score)
    }
}
