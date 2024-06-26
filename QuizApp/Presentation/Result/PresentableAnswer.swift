//
//  PresentableAnswer.swift
//  QuizApp
//
//  Created by Саша Восколович on 26.02.2024.
//

import Foundation

struct PresentableAnswer: Equatable {
    let question: String
    let answer: String
    let wrongAnswer: String?
}
