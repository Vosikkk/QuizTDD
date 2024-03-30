//
//  iOSSwiftUIViewControllerFactory.swift
//  QuizApp
//
//  Created by Саша Восколович on 22.03.2024.
//

import SwiftUI
import UIKit
import QuizEngine


class QuizNavigationStore: ObservableObject {
    
    @Published var currentView: CurrentView?
    
    enum CurrentView {
        case single(SingleAnswerQuestion)
        case multiple(MultipleAnswerQuestion)
        case result(ResultView)
    }
}


final class iOSSwiftUINavigationAdapter: QuizDelegate {
   
    typealias Question = QuizEngine.Question<String>
    
    typealias Answer = [String]
    
    typealias Answers = [(question: Question, answer: Answer)]
    
    private let options: [Question: Answer]
    
    private let correctAnswers: Answers
    
    private var questions: [Question] {
        correctAnswers.map { $0.question }
    }
    
    private let show: (QuizNavigationStore.CurrentView?) -> Void
    
    private let playAgain: () -> Void
    
    
    init(
        show: @escaping (QuizNavigationStore.CurrentView?) -> Void,
        options: [Question: Answer],
        correctAnswers: Answers,
        playAgain: @escaping () -> Void
    ) {
        self.show = show
        self.options = options
        self.correctAnswers = correctAnswers
        self.playAgain = playAgain
    }
    
    
    func answer(for question: Question, completion: @escaping (Answer) -> Void) {
        
        guard let options = options[question] else {
            fatalError("Couldn't find options for qoestion: \(question)")
        }
        
        let presenter = QuestionPresenter(questions: questions, question: question)
        
        switch question {
        case .singleAnswer(let value):
            show(.single(SingleAnswerQuestion(
                title: presenter.title,
                question: value,
                options: options,
                selection: { completion([$0]) } 
            )
            )
            )
            
        case .multipleAnswer(let value):
            show(.multiple(MultipleAnswerQuestion(
                title: presenter.title,
                question: value,
                store: .init(options: options, handler: completion)
            )
            )
            )
        }
    }
    
    
    func didCompleteQuiz(withAnswers answers: Answers) {
        let presenter = ResultsPresenter(
            userAnswers: answers,
            correctAnswers: correctAnswers,
            scorer: BasicScore.score
        )
        
        show(.result(ResultView(
            title: presenter.title,
            summary: presenter.summary,
            answers: presenter.presentableAnswers,
            playAgain: playAgain
        )
        )
        )
    }
    
    
    // MARK: - Helpers
    
    private func questionViewController(
        for question: Question,
        options: Answer,
        answerCallback: @escaping (Answer) -> Void
    ) -> UIViewController {
        
        let presenter = QuestionPresenter(questions: questions, question: question)
        
        switch question {
        case .singleAnswer(let value):
            return UIHostingController(
                rootView: SingleAnswerQuestion(
                    title: presenter.title,
                    question: value,
                    options: options,
                    selection: { answerCallback([$0])} )
            )
           
        case .multipleAnswer(let value):
            return UIHostingController(
                rootView: MultipleAnswerQuestion(
                    title: presenter.title,
                    question: value,
                    store: .init(options: options, handler: answerCallback)))
        }
    }
}

