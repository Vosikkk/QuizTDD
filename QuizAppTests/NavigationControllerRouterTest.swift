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
    
    lazy var sut: NavigationControllerRouter = { NavigationControllerRouter(navigationController, factory: factory) }()
    
    func test_routeToQuestion_showsQuestionController() {
        let viewController = UIViewController()
        let secondViewController = UIViewController()
        
        factory.stub(question: Question.singleAnswer("Q1"), with: viewController)
        factory.stub(question: Question.singleAnswer("Q2"), with: secondViewController)
        
        sut.routeTo(question: Question.singleAnswer("Q1") , answerCallback: { _ in })
        sut.routeTo(question: Question.singleAnswer("Q2"), answerCallback: { _ in })
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    func test_routeToQuestion_presentsQuestionControllerWithRightCallback() {
        var callBackWasFired: Bool = false
        
        sut.routeTo(question: Question.singleAnswer("Q1"), answerCallback: { _ in  callBackWasFired = true })
        factory.answerCallbacks[Question.singleAnswer("Q1")]!(["anything"])
       
        XCTAssertTrue(callBackWasFired)
    }
    
    
    func test_routeToResult_showsResultController() {
        let viewController = UIViewController()
        let secondViewController = UIViewController()
        
        
        let result = Result(answers: [Question.singleAnswer("Q1"): ["A1"]], score: 10)
        let secondResult = Result(answers: [Question.singleAnswer("Q2"): ["A2"]], score: 9)
        factory.stub(result: result, with: viewController)
        factory.stub(result: secondResult, with: secondViewController)
        
        sut.routeTo(result: result)
        sut.routeTo(result: secondResult)
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
       
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

extension Result: Hashable {
    public static func == (lhs: Result<Question, Answer>, rhs: Result<Question, Answer>) -> Bool {
        return lhs.score == rhs.score
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(1)
    }
}
