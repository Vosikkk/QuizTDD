//
//  iOSSwiftUIViewControllerFactoryTest.swift
//  QuizAppTests
//
//  Created by Саша Восколович on 22.03.2024.
//

import SwiftUI
import XCTest
import QuizEngine
@testable import QuizApp


final class iOSSwiftUIViewControllerFactoryTest: XCTestCase {

    func test_questionViewController_singleAnswer_createsViewControllerWithTitle() throws {
        let presenter = QuestionPresenter(questions: [singleAnswerQuestion, multipleAnswerQuestion], question: singleAnswerQuestion)
        let view = try XCTUnwrap(makeSingleAnswerQuestion())
        XCTAssertEqual(view.title, presenter.title)
    }
    
    func test_questionViewController_singleAnswer_createsViewControllerWithQuestion() throws {
        let view = try XCTUnwrap(makeSingleAnswerQuestion())
        XCTAssertEqual(view.question, "Q1")
    }
    
    func test_questionViewController_singleAnswer_createsViewControllerWithOptions() throws {
        let view = try XCTUnwrap(makeSingleAnswerQuestion())
        XCTAssertEqual(view.options, options[singleAnswerQuestion])
    }
    
    
    func test_questionViewController_singleAnswer_createsViewControllerWithAnswerCallback() throws {
        var answers: [[String]] = []
        let view = try XCTUnwrap(makeSingleAnswerQuestion(answerCallback: { answers.append($0) }))
        XCTAssertEqual(answers, [])
        
        view.selection(view.options[0])
        XCTAssertEqual(answers, [[view.options[0]]])
        
        view.selection(view.options[1])
        XCTAssertEqual(answers, [[view.options[0]], [view.options[1]]])
    }
    
    
    func test_questionViewController_multipleAnswer_createsViewControllerWithTitle() throws {
        
        let presenter = QuestionPresenter(questions: [singleAnswerQuestion, multipleAnswerQuestion], question: multipleAnswerQuestion)
        let view = try XCTUnwrap(makeMultipleAnswerQuestion())
        XCTAssertEqual(view.title, presenter.title)
    }
    
    func test_questionViewController_multipleAnswer_createsViewControllerWithQuestion() throws {
        let view = try XCTUnwrap(makeMultipleAnswerQuestion())
        XCTAssertEqual(view.question, "Q2")
    }
    
    func test_questionViewController_multipleAnswer_createsViewControllerWithOptions() throws {
        let view = try XCTUnwrap(makeMultipleAnswerQuestion())

        XCTAssertEqual(view.store.options.map(\.text), options[multipleAnswerQuestion])
    }
   
    func test_resultViewController_createsControllerWithSummary() throws {
        let (view, presenter) =  try XCTUnwrap(makeResults())
        XCTAssertEqual(view.summary, presenter.summary)
    }
    
    func test_resultViewController_createsControllerWithPresentableAnswers() throws {
        let (view, presenter) =  try XCTUnwrap(makeResults())
        XCTAssertEqual(view.answers, presenter.presentableAnswers)
    }
    
    func test_resultViewController_createsControllerWithTitle() throws {
        let (view, presenter) =  try XCTUnwrap(makeResults())
        XCTAssertEqual(view.title, presenter.title)
    }
    
    
    
    // MARK: - Helpers
    
    
    private var singleAnswerQuestion: Question<String> { .singleAnswer("Q1") }
    private var multipleAnswerQuestion: Question<String> { .multipleAnswer("Q2") }
    
    private var questions: [Question<String>] {
        [singleAnswerQuestion, multipleAnswerQuestion]
    }
    
    private var options: [Question<String>: [String]] {
        [singleAnswerQuestion: ["A1", "A2", "A3"], multipleAnswerQuestion: ["A4", "A5", "A6"]]
    }
    
    private var correctAnswers: [(Question<String>, [String])] {
        [(singleAnswerQuestion, ["A1"]), (multipleAnswerQuestion, ["A4, A5"])]
    }
    
    func makeSUT() -> iOSSwiftUIViewControllerFactory {
        iOSSwiftUIViewControllerFactory(options: options, correctAnswers: correctAnswers)
    }
    
    func makeSingleAnswerQuestion(answerCallback: @escaping ([String]) -> Void = { _ in }) -> SingleAnswerQuestion? {
        let sut = makeSUT()
        let controller = sut.questionViewController(for: singleAnswerQuestion, answerCallback: answerCallback) as? UIHostingController<SingleAnswerQuestion>
        return controller?.rootView
    }

    
    func makeMultipleAnswerQuestion(answerCallback: @escaping ([String]) -> Void = { _ in }) -> MultipleAnswerQuestion? {
        let sut = makeSUT()
        let controller = sut.questionViewController(for: multipleAnswerQuestion, answerCallback: answerCallback) as? UIHostingController<MultipleAnswerQuestion>
        return controller?.rootView
    }

    
    func makeResults() -> (view: ResultView, presenter: ResultsPresenter)? {
        let sut = makeSUT()

        let presenter = ResultsPresenter(userAnswers: correctAnswers, correctAnswers: correctAnswers, scorer: BasicScore.score)
        
        let controller = sut.resultsViewController(for: correctAnswers) as? UIHostingController<ResultView>
        
        return controller.map { ($0.rootView, presenter) }
    }
}
