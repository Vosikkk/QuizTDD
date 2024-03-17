//
//  BasicScore.swift
//  QuizApp
//
//  Created by Саша Восколович on 17.03.2024.
//

import Foundation

final class BasicScore {
    static func score<T: Equatable>(for answers: [T], comparingTo correctAnswers: [T]) -> Int {
        zip(answers, correctAnswers).reduce(0) { score, tuple in
            score + (tuple.0 == tuple.1 ? 1 : 0)
        }
    }
}
