//
//  iOSViewControllerFactoryTest.swift
//  QuizAppTests
//
//  Created by Саша Восколович on 03.03.2024.
//

import XCTest
import QuizEngine
@testable import QuizApp

final class iOSViewControllerFactoryTest: XCTestCase {

    let options = ["A1", "A2"]
    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let multipleAnswerQuestion = Question.multipleAnswer("Q1")
    
    func test_questionViewController_singleAnswer_createsViewControllerWithTitle() {
        let presenter = QuestionPresenter(questions: [singleAnswerQuestion, multipleAnswerQuestion], question: singleAnswerQuestion)
        XCTAssertEqual(makeQuestionController(question: singleAnswerQuestion).title, presenter.title)
    }
    
    func test_questionViewController_singleAnswer_createsViewControllerWithQuestion() {
        XCTAssertEqual(makeQuestionController(question: singleAnswerQuestion).question, "Q1")
    }
    
    func test_questionViewController_singleAnswer_createsViewControllerWithOptions() {
        XCTAssertEqual(makeQuestionController(question: singleAnswerQuestion).options, options)
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
        XCTAssertEqual(makeQuestionController(question: multipleAnswerQuestion).options, options)
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
    
    func makeSUT(options: [Question<String>: [String]] = [:], correctAnswers: [(Question<String>, [String])] = []) -> iOSViewControllerFactory {
        iOSViewControllerFactory(options: options, correctAnswers: correctAnswers)
    }
    
    
    func makeQuestionController(question: Question<String> = Question.singleAnswer("")) -> QuestionViewController {
        let sut = makeSUT(
            options: [question: options],
            correctAnswers: [(singleAnswerQuestion, []), (multipleAnswerQuestion, [])]
        )
        return sut.questionViewController(for: question, answerCallback: { _ in }) as! QuestionViewController
    }

    
    func makeResultController() -> (controller: ResultsViewController, presenter: ResultsPresenter) {
        let correctAnswers = [(singleAnswerQuestion, ["A1"]), (multipleAnswerQuestion, ["A1, A2"])]
        let userAnswers = [(singleAnswerQuestion, ["A1"]), (multipleAnswerQuestion, ["A1, A2"])]
       
        let sut = makeSUT(correctAnswers: correctAnswers)

        let presenter = ResultsPresenter(userAnswers: userAnswers, correctAnswers: correctAnswers, scorer: BasicScore.score)
        
        let controller = sut.resultsViewController(for: userAnswers) as! ResultsViewController
        
        return (controller, presenter)
    }
}
