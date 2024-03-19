//
//  NavigationControllerRouterTest.swift
//  QuizAppTests
//
//  Created by Саша Восколович on 02.03.2024.
//

import XCTest
import QuizEngine
@testable import QuizApp

final class NavigationControllerRouterTest: XCTestCase {
    
    let navigationController: UINavigationController = NonAnimatedNavigationController()
    let factory: ViewControllerFactoryStub = ViewControllerFactoryStub()
    
    lazy var sut: NavigationControllerRouter = NavigationControllerRouter(navigationController, factory: factory)
    
    let multipleQuestionAnswer = Question.multipleAnswer("Q1")
    let singleQuestionAnswer = Question.singleAnswer("Q1")
    let singleQuestionAnswer2 = Question.singleAnswer("Q2")
    
    func test_answerToQuestion_showsQuestionController() {
        let viewController = UIViewController()
        let secondViewController = UIViewController()
        
        
        
        factory.stub(question: singleQuestionAnswer, with: viewController)
        factory.stub(question: singleQuestionAnswer2, with: secondViewController)
        
        sut.answer(for: singleQuestionAnswer, completion: { _ in })
        sut.answer(for: singleQuestionAnswer2, completion: { _ in })
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    func test_answerForQuestion_singleAnswer_answerCallback_progressesToNextQuestion() {
        var callBackWasFired: Bool = false
        sut.answer(for: singleQuestionAnswer, completion: { _ in callBackWasFired = true })
        factory.answerCallbacks[singleQuestionAnswer]!(["anything"])
       
        XCTAssertTrue(callBackWasFired)
    }
    
    func test_answerForQuestion_multipleAnswer_answerCallback_doesNotProgressesToNextQuestion() {
        var callBackWasFired: Bool = false
        sut.answer(for: multipleQuestionAnswer, completion: { _ in callBackWasFired = true })
        factory.answerCallbacks[multipleQuestionAnswer]!(["anything"])
       
        XCTAssertFalse(callBackWasFired)
    }
    
    
    func test_answerForQuestion_multipleAnswer_answerCallback_configureViewControllerWithSubmitButton() {
        let viewController = UIViewController()
        factory.stub(question: multipleQuestionAnswer, with: viewController)
        sut.answer(for: multipleQuestionAnswer, completion: { _ in })
        
        XCTAssertNotNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    
    func test_answerForQuestion_singleAnswer_answerCallback_doesNotConfigureViewControllerWithSubmitButton() {
        let viewController = UIViewController()
        factory.stub(question: singleQuestionAnswer, with: viewController)
        sut.answer(for: singleQuestionAnswer, completion: { _ in })
        
        XCTAssertNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    
    
    func test_answerForQuestion_multipleAnswerSubmitButton_isDisabledWhenZeroAnswerSelected() {
        let viewController = UIViewController()
    
        factory.stub(question: multipleQuestionAnswer, with: viewController)
        sut.answer(for: multipleQuestionAnswer, completion: { _ in })
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
        
        factory.answerCallbacks[multipleQuestionAnswer]!(["A1"])
        XCTAssertTrue(viewController.navigationItem.rightBarButtonItem!.isEnabled)
        
        factory.answerCallbacks[multipleQuestionAnswer]!([])
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
    }
    
    
    func test_answerForQuestion_multipleAnswerSubmitButton_progressesToNextQuestion() {
        let viewController = UIViewController()
        factory.stub(question: multipleQuestionAnswer, with: viewController)
        
        var callBackWasFired: Bool = false
        
        sut.answer(for: multipleQuestionAnswer, completion: { _ in callBackWasFired = true })
        
        factory.answerCallbacks[multipleQuestionAnswer]!(["A1"])
        
        tap(viewController.navigationItem.rightBarButtonItem!)
        
        XCTAssertTrue(callBackWasFired)
    }
    
    
    func test_didCompleteQuiz_showsResultsController() {
        let viewController = UIViewController()
        let secondViewController = UIViewController()
    
        
        let userAnswers = [(singleQuestionAnswer, ["A1"])]
        let secondUserAnswers = [(multipleQuestionAnswer, ["A2"])]
        factory.stub(resultForQuestions: [singleQuestionAnswer] , with: viewController)
        factory.stub(resultForQuestions: [multipleQuestionAnswer], with: secondViewController)
        
        sut.didCompleteQuiz(withAnswers: userAnswers)
        sut.didCompleteQuiz(withAnswers: secondUserAnswers)
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
       
    }
    
    
    // MARK: - Helpers
    
    func tap(_ button: UIBarButtonItem) {
        _ = button.target?.perform(button.action, with: nil)
    }
    
    class NonAnimatedNavigationController: UINavigationController {
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            super.pushViewController(viewController, animated: false)
        }
    }
    
    
    class ViewControllerFactoryStub: ViewControllerFactory {
      
        private var stubbedQuestions: [Question<String>: UIViewController] = [:]
        private var stubbedResults: [[Question<String>]: UIViewController] = [:]
        var answerCallbacks: [Question<String>: ([String]) -> Void] = [:]
        
        func stub(question: Question<String>, with viewController: UIViewController) {
            stubbedQuestions[question] = viewController
        }
        
        func stub(resultForQuestions questions: [Question<String>], with viewController: UIViewController) {
             stubbedResults[questions] = viewController
        }
        
        func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
            answerCallbacks[question] = answerCallback
            return stubbedQuestions[question] ?? UIViewController()
        }
        
        func resultsViewController(for userAnswers: Answers) -> UIViewController {
            stubbedResults[userAnswers.map { $0.question }] ?? UIViewController()
        }
        
        func resultViewController(for result: Result<Question<String>, [String]>) -> UIViewController {
             UIViewController()
        }
    }
}

