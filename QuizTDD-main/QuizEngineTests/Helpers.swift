//
//  Helpers.swift
//  QuizEngineTests
//
//  Created by Саша Восколович on 25.02.2024.
//

import Foundation
@testable import QuizEngine

class RouterSpy: Router {

    var routedQuestions: [String] = []
    var answerCallback: (String) -> Void = { _ in }
    var routedResult: Result<String, String>? = nil
    
    func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
        routedQuestions.append(question)
        self.answerCallback = answerCallback
    }
    
    func routeTo(result: Result<String, String>) {
        routedResult = result
    }
}




