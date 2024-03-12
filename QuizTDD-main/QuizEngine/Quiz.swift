//
//  Quiz.swift
//  QuizEngine
//
//  Created by Саша Восколович on 13.03.2024.
//

import Foundation

public final class Quiz {
    
    private let flow: Any
    
    init(flow: Any) {
        self.flow = flow
    }
    
    public static func start<Question, Answer: Equatable, Delegate: QuizDelegate>(questions: [Question], delegate: Delegate,  correctAnswers: [Question: Answer]) -> Quiz where Delegate.Question == Question, Delegate.Answer == Answer {
        let flow = Flow(questions: questions, delegate: delegate, scoring:  { scoring($0, correctAnswers: correctAnswers) } )
        flow.start()
        return Quiz(flow: flow)
    }
}

func scoring<Question, Answer: Equatable>(_ answers: [Question: Answer], correctAnswers: [Question: Answer]) -> Int {
     answers.reduce(0) { (score, tuple) in
         score + (correctAnswers[tuple.key] == tuple.value ? 1 : 0)
    }
}
