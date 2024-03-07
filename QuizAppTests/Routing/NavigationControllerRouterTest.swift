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
    
    func test_routeToQuestion_showsQuestionController() {
        let viewController = UIViewController()
        let secondViewController = UIViewController()
        
        
        
        factory.stub(question: singleQuestionAnswer, with: viewController)
        factory.stub(question: singleQuestionAnswer2, with: secondViewController)
        
        sut.routeTo(question: singleQuestionAnswer, answerCallback: { _ in })
        sut.routeTo(question: singleQuestionAnswer2, answerCallback: { _ in })
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    func test_routeToQuestion_singleAnswer_answerCallback_progressesToNextQuestion() {
        var callBackWasFired: Bool = false
        sut.routeTo(question: singleQuestionAnswer, answerCallback: { _ in callBackWasFired = true })
        factory.answerCallbacks[singleQuestionAnswer]!(["anything"])
       
        XCTAssertTrue(callBackWasFired)
    }
    
    func test_routeToQuestion_multipleAnswer_answerCallback_doesNotProgressesToNextQuestion() {
        var callBackWasFired: Bool = false
        sut.routeTo(question: multipleQuestionAnswer, answerCallback: { _ in callBackWasFired = true })
        factory.answerCallbacks[multipleQuestionAnswer]!(["anything"])
       
        XCTAssertFalse(callBackWasFired)
    }
    
    
    func test_routeToQuestion_multipleAnswer_answerCallback_configureViewControllerWithSubmitButton() {
        let viewController = UIViewController()
        factory.stub(question: multipleQuestionAnswer, with: viewController)
        sut.routeTo(question: multipleQuestionAnswer, answerCallback: { _ in })
        
        XCTAssertNotNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    
    func test_routeToQuestion_singleAnswer_answerCallback_doesNotConfigureViewControllerWithSubmitButton() {
        let viewController = UIViewController()
        factory.stub(question: singleQuestionAnswer, with: viewController)
        sut.routeTo(question: singleQuestionAnswer, answerCallback: { _ in })
        
        XCTAssertNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    
    
    func test_routeToQuestion_multipleAnswerSubmitButton_isDisabledWhenZeroAnswerSelected() {
        let viewController = UIViewController()
    
        factory.stub(question: multipleQuestionAnswer, with: viewController)
        sut.routeTo(question: multipleQuestionAnswer, answerCallback: { _ in })
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
        
        factory.answerCallbacks[multipleQuestionAnswer]!(["A1"])
        XCTAssertTrue(viewController.navigationItem.rightBarButtonItem!.isEnabled)
        
        factory.answerCallbacks[multipleQuestionAnswer]!([])
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
    }
    
    
    func test_routeToQuestion_multipleAnswerSubmitButton_progressesToNextQuestion() {
        let viewController = UIViewController()
        factory.stub(question: multipleQuestionAnswer, with: viewController)
        
        var callBackWasFired: Bool = false
        
        sut.routeTo(question: multipleQuestionAnswer, answerCallback: { _ in callBackWasFired = true })
        
        factory.answerCallbacks[multipleQuestionAnswer]!(["A1"])
        
        tap(viewController.navigationItem.rightBarButtonItem!)
        
        XCTAssertTrue(callBackWasFired)
    }
    
    
    func test_routeToResult_showsResultController() {
        let viewController = UIViewController()
        let secondViewController = UIViewController()
    
        
        let result = Result.make(answers: [singleQuestionAnswer: ["A1"]], score: 10)
        let secondResult = Result.make(answers: [singleQuestionAnswer2: ["A2"]], score: 9)
        factory.stub(result: result, with: viewController)
        factory.stub(result: secondResult, with: secondViewController)
        
        sut.routeTo(result: result)
        sut.routeTo(result: secondResult)
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
        private var stubbedResults: [Result<Question<String>, [String]>: UIViewController] = [:]
        var answerCallbacks: [Question<String>: ([String]) -> Void] = [:]
        
        func stub(question: Question<String>, with viewController: UIViewController) {
            stubbedQuestions[question] = viewController
        }
        
        func stub(result: Result<Question<String>, [String]>, with viewController: UIViewController) {
             stubbedResults[result] = viewController
        }
        
        func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
            answerCallbacks[question] = answerCallback
            return stubbedQuestions[question] ?? UIViewController()
        }
        
        func resultViewController(for result: Result<Question<String>, [String]>) -> UIViewController {
            stubbedResults[result] ?? UIViewController()
        }
    }
}


