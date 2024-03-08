//
//  Result.swift
//  QuizEngine
//
//  Created by Саша Восколович on 26.02.2024.
//

import Foundation

public struct Result<Question: Hashable, Answer> {
    public let answers: [Question: Answer]
    public let score: Int
}
