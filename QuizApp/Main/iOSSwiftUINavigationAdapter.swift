//
//  iOSSwiftUIViewControllerFactory.swift
//  QuizApp
//
//  Created by Саша Восколович on 22.03.2024.
//

import SwiftUI
import UIKit
import QuizEngine


final class iOSSwiftUINavigationAdapter: QuizDelegate {
   
    typealias Question = QuizEngine.Question<String>
    
    typealias Answer = [String]
    
    typealias Answers = [(question: Question, answer: Answer)]
    
    private let options: [Question: Answer]
    
    private let correctAnswers: Answers
    
    private var questions: [Question] {
        correctAnswers.map { $0.question }
    }
    
   // private let show: (QuizNavigationStore.CurrentView?) -> Void
    private let navigation: QuizNavigationStore
    
    private let playAgain: () -> Void
    
    
    init(
        navigation: QuizNavigationStore,
        options: [Question: Answer],
        correctAnswers: Answers,
        playAgain: @escaping () -> Void
    ) {
        self.navigation = navigation
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
            navigation.currentView = .single(SingleAnswerQuestion(
                title: presenter.title,
                question: value,
                options: options,
                selection: { completion([$0]) } 
            )
            )
            
        case .multipleAnswer(let value):
            navigation.currentView = .multiple(MultipleAnswerQuestion(
                title: presenter.title,
                question: value,
                store: .init(options: options, handler: completion)
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
        
        navigation.currentView = .result(ResultView(
            title: presenter.title,
            summary: presenter.summary,
            answers: presenter.presentableAnswers,
            playAgain: playAgain
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

