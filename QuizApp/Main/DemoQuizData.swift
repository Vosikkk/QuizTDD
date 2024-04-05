//
//  DemoQuizData.swift
//  QuizApp
//
//  Created by Саша Восколович on 05.04.2024.
//

import Foundation
import QuizEngine


let demoQuiz = try! BasicQuizBuilder(singleAnswerQuestion: "What's Mike's nationality?", options: .init("Canadian", ["American", "Ukrainian"]), answer: "Ukrainian")
    .adding(question: Question.multipleAnswer("What are Sasha's nationalities?"), options: ["Canadian", "American", "Ukrainian"], answer: ["American", "Ukrainian"])
    .build()



public struct BasicQuiz {
    public let questions: [Question<String>]
    public let options: [Question<String>: [String]]
    public let correctAnswers: [(Question<String>, [String])]
}

public struct NonEmptyOptions {
    let head: String
    let tail: [String]
    
    public init(_ head: String, _ tail: [String]) {
        self.head = head
        self.tail = tail
    }
    
    var all: [String] {
        [head] + tail
    }
}

public struct BasicQuizBuilder {
     
    private var questions: [Question<String>] = []
    private var options: [Question<String>: [String]] = [:]
    private var correctAnswers: [(Question<String>, [String])] = []
    
    
    public init(singleAnswerQuestion: String, options: NonEmptyOptions, answer: String) throws {
        try add(singleAnswerQuestion: singleAnswerQuestion, options: options, answer: answer)
    }
    
    public init(multipleAnswerQuestion: String, options: NonEmptyOptions, answer: NonEmptyOptions) throws {
        try add(multipleAnswerQuestion: multipleAnswerQuestion, options: options, answer: answer)
    }
    
    private init(questions: [Question<String>],
                 options: [Question<String> : [String]],
                 correctAnswers: [(Question<String>, [String])]) {
        self.questions = questions
        self.options = options
        self.correctAnswers = correctAnswers
    }
    
    public func build() -> BasicQuiz {
        BasicQuiz(questions: questions, options: options, correctAnswers: correctAnswers)
    }
    
    public mutating func add(multipleAnswerQuestion: String, options: NonEmptyOptions, answer: NonEmptyOptions) throws {
        self = try adding(multipleAnswerQuestion: multipleAnswerQuestion, options: options, answer: answer)
    }
    
    
    public mutating func add(singleAnswerQuestion: String, options: NonEmptyOptions, answer: String) throws {
        self = try adding(singleAnswerQuestion: singleAnswerQuestion, options: options, answer: answer)
    }
    
    
    public func adding(multipleAnswerQuestion: String, options: NonEmptyOptions, answer: NonEmptyOptions) throws -> BasicQuizBuilder {
        try adding(question: Question.multipleAnswer(multipleAnswerQuestion), options: options.all, answer: answer.all)
       
    }
    
    public func adding(singleAnswerQuestion: String, options: NonEmptyOptions , answer: String) throws -> BasicQuizBuilder {
        try adding(question: Question.singleAnswer(singleAnswerQuestion), options: options.all, answer: [answer])
       
    }
    
    public func adding(question: Question<String>, options: [String], answer: [String]) throws -> BasicQuizBuilder {
       
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
    
    public enum AddingError: Equatable, Error {
        case duplicateOptions([String])
        case missingAnswerInOptions(answer: [String], options: [String])
        case duplicateQuestion(Question<String>)
        case duplicateAnswers([String])
    }
}

