//
//  iOSViewControllerFactoryTest.swift
//  QuizAppTests
//
//  Created by Саша Восколович on 03.03.2024.
//

import XCTest
import QuizEngine
@testable import QuizApp

final class iOSUIKitViewControllerFactoryTest: XCTestCase {

    
    func test_questionViewController_singleAnswer_createsViewControllerWithTitle() {
        let presenter = QuestionPresenter(questions: [singleAnswerQuestion, multipleAnswerQuestion], question: singleAnswerQuestion)
        XCTAssertEqual(makeQuestionController(question: singleAnswerQuestion).title, presenter.title)
    }
    
    func test_questionViewController_singleAnswer_createsViewControllerWithQuestion() {
        XCTAssertEqual(makeQuestionController(question: singleAnswerQuestion).question, "Q1")
    }
    
    func test_questionViewController_singleAnswer_createsViewControllerWithOptions() {
        XCTAssertEqual(makeQuestionController(question: singleAnswerQuestion).options, options[singleAnswerQuestion])
    }
    
    func test_questionViewController_singleAnswer_createsViewControllerWithSingleSelection() {
        XCTAssertFalse(makeQuestionController(question: singleAnswerQuestion).allowMultipleSelection)
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
    
    
    func makeSUT() -> iOSUIKitViewControllerFactory {
        iOSUIKitViewControllerFactory(options: options, correctAnswers: correctAnswers)
    }
    
    
    func makeQuestionController(question: Question<String> = Question.singleAnswer(""), answerCallback: @escaping ([String]) -> Void = { _ in }) -> QuestionViewController {
        let sut = makeSUT()
        return sut.questionViewController(for: question, answerCallback: answerCallback) as! QuestionViewController
    }

    
    func makeResultController() -> (controller: ResultsViewController, presenter: ResultsPresenter) {
        let userAnswers = [(singleAnswerQuestion, ["A1"]), (multipleAnswerQuestion, ["A1, A2"])]
       
        let sut = makeSUT()

        let presenter = ResultsPresenter(userAnswers: userAnswers, correctAnswers: correctAnswers, scorer: BasicScore.score)
        
        let controller = sut.resultsViewController(for: userAnswers) as! ResultsViewController
        
        return (controller, presenter)
    }
}
