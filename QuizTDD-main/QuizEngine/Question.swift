//
//  Question.swift
//  QuizApp
//
//  Created by Саша Восколович on 03.03.2024.
//

import Foundation


public enum Question<T: Hashable>: Hashable {
    case singleAnswer(T)
    case multipleAnswer(T)
}

