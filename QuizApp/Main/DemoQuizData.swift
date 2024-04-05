//
//  DemoQuizData.swift
//  QuizApp
//
//  Created by Саша Восколович on 05.04.2024.
//

import Foundation
import QuizEngine


let demoQuiz = try! BasicQuizBuilder(singleAnswerQuestion: "What's Mike's nationality?", options: .init("Canadian", ["American", "Ukrainian"]), answer: "Ukrainian")
    .adding(question: Question.multipleAnswer("What are Sasha's nationalities?"), options: ["Canadian", "American", "Ukrainian"], answers: ["American", "Ukrainian"])
    .build()



struct BasicQuiz {
    let questions: [Question<String>]
    let options: [Question<String>: [String]]
    let correctAnswers: [(Question<String>, [String])]
}

struct NonEmptyOptions {
    let head: String
    let tail: [String]
    
    init(_ head: String, _ tail: [String]) {
        self.head = head
        self.tail = tail
    }
    
    var all: [String] {
        [head] + tail
    }
}

struct BasicQuizBuilder {
     
    private var questions: [Question<String>] = []
    private var options: [Question<String>: [String]] = [:]
    private var correctAnswers: [(Question<String>, [String])] = []
    
    
    init(singleAnswerQuestion: String, options: NonEmptyOptions, answer: String) throws {
        try add(singleAnswerQuestion: singleAnswerQuestion, options: options, answer: answer)
    }
    
    init(multipleAnswerQuestion: String, options: NonEmptyOptions, answers: NonEmptyOptions) throws {
        try add(multipleAnswerQuestion: multipleAnswerQuestion, options: options, answers: answers)
    }
    
    private init(questions: [Question<String>],
                 options: [Question<String> : [String]],
                 correctAnswers: [(Question<String>, [String])]) {
        self.questions = questions
        self.options = options
        self.correctAnswers = correctAnswers
    }
    
    func build() -> BasicQuiz {
        BasicQuiz(questions: questions, options: options, correctAnswers: correctAnswers)
    }
    
    mutating func add(multipleAnswerQuestion: String, options: NonEmptyOptions, answers: NonEmptyOptions) throws {
        self = try adding(question: Question.multipleAnswer(multipleAnswerQuestion), options: options.all, answers: answers.all)
    }
    
    
    mutating func add(singleAnswerQuestion: String, options: NonEmptyOptions, answer: String) throws {
        self = try adding(question: Question.singleAnswer(singleAnswerQuestion), options: options.all, answer: [answer])
    }
    
    
    func adding(question: Question<String>, options: [String], answers: [String]) throws -> BasicQuizBuilder {
        
        guard !questions.contains(question) else {
            throw AddingError.duplicateQuestion(question)
        }
        
        guard Set(options).count == options.count else {
            throw AddingError.duplicateOptions(options)
        }
       
        guard Set(answers).isSubset(of: Set(options)) else {
            throw AddingError.missingAnswerInOptions(answer: answers, options: options)
        }
        
        guard Set(answers).count == answers.count else {
            throw AddingError.duplicateAnswers(answers)
        }
    
        var newOptions = self.options
        newOptions[question] = options
        
        return BasicQuizBuilder(
            questions: questions + [question],
            options: newOptions,
            correctAnswers: correctAnswers + [(question, answers)]
        )
    }
    
    
    func adding(question: Question<String>, options: [String], answer: [String]) throws -> BasicQuizBuilder {
       
        guard !questions.contains(question) else {
            throw AddingError.duplicateQuestion(question)
        }
        
        guard Set(options).count == options.count else {
            throw AddingError.duplicateOptions(options)
        }
       
        guard Set(answer).isSubset(of: Set(options)) else {
            throw AddingError.missingAnswerInOptions(answer: answer, options: options)
        }
    
        var newOptions = self.options
        newOptions[question] = options
        
        return BasicQuizBuilder(
            questions: questions + [question],
            options: newOptions,
            correctAnswers: correctAnswers + [(question, answer)]
        )
    }
    
    enum AddingError: Equatable, Error {
        case duplicateOptions([String])
        case missingAnswerInOptions(answer: [String], options: [String])
        case duplicateQuestion(Question<String>)
        case duplicateAnswers([String])
    }
}

