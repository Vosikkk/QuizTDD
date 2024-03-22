//
//  iOSSwiftUIViewControllerFactoryTest.swift
//  QuizAppTests
//
//  Created by Саша Восколович on 22.03.2024.
//

import XCTest
import QuizEngine
@testable import QuizApp
import SwiftUI

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
    
    
    func test_questionViewController_multipleAnswer_createsViewControllerWithTitle() {
        
        let presenter = QuestionPresenter(questions: [singleAnswerQuestion, multipleAnswerQuestion], question: multipleAnswerQuestion)
        XCTAssertEqual(makeQuestionController(question: multipleAnswerQuestion).title, presenter.title)
    }
    
    func test_questionViewController_multipleAnswer_createsViewControllerWithQuestion() {
        XCTAssertEqual(makeQuestionController(question: multipleAnswerQuestion).question, "Q1")
    }
    
    func test_questionViewController_multipleAnswer_createsViewControllerWithOptions() {
        XCTAssertEqual(makeQuestionController(question: multipleAnswerQuestion).options, options[multipleAnswerQuestion])
    }
    
    func test_questionViewController_multipleAnswer_createsViewControllerWithSingleSelection() {
        XCTAssertTrue(makeQuestionController(question: multipleAnswerQuestion).allowMultipleSelection)
    }
    
    
    func test_resultViewController_createsControllerWithSummary() {
        let results = makeResultController()
        XCTAssertEqual(results.controller.summary, results.presenter.summary)
    }
    
    func test_resultViewController_createsControllerWithPresentableAnswers() {
        let results = makeResultController()
        XCTAssertEqual(results.controller.answers.count, results.presenter.presentableAnswers.count)
    }
    
    func test_resultViewController_createsControllerWithTitle() {
        let results = makeResultController()
        XCTAssertEqual(results.controller.title, results.presenter.title)
    }
    
    
    
    // MARK: - Helpers
    
    
    private var singleAnswerQuestion: Question<String> { .singleAnswer("Q1") }
    private var multipleAnswerQuestion: Question<String> { .multipleAnswer("Q1") }
    
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

    
    func makeQuestionController(question: Question<String> = Question.singleAnswer(""), answerCallback: @escaping ([String]) -> Void = { _ in }) -> QuestionViewController {
        let sut = makeSUT()
        return sut.questionViewController(for: question, answerCallback: answerCallback) as! QuestionViewController
    }

    
    func makeResultController() -> (controller: ResultsViewController, presenter: ResultsPresenter) {
        let userAnswers = [(singleAnswerQuestion, ["A1"]), (multipleAnswerQuestion, ["A4, A5"])]
       
        let sut = makeSUT()

        let presenter = ResultsPresenter(userAnswers: userAnswers, correctAnswers: correctAnswers, scorer: BasicScore.score)
        
        let controller = sut.resultsViewController(for: userAnswers) as! ResultsViewController
        
        return (controller, presenter)
    }
}
