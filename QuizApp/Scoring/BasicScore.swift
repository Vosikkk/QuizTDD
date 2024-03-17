//
//  BasicScore.swift
//  QuizApp
//
//  Created by Саша Восколович on 17.03.2024.
//

import Foundation

final class BasicScore {
   
    static func score(for answers: [String], comparingTo correctAnswers: [String]) -> Int {
        zip(answers, correctAnswers).reduce(0) { score, tuple in
            score + (tuple.0 == tuple.1 ? 1 : 0)
        }
    }
}
