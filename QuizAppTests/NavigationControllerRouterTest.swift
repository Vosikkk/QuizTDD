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
    
    func test_routeToQuestion_showsQuestionController() {
        let viewController = UIViewController()
        let secondViewController = UIViewController()
        
        factory.stub(question: "Q1", with: viewController)
        factory.stub(question: "Q2", with: secondViewController)
        
        sut.routeTo(question: "Q1", answerCallback: { _ in })
        sut.routeTo(question: "Q2", answerCallback: { _ in })
        
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    func test_routeToQuestion_presentsQuestionControllerWithRightCallback() {
        var callBackWasFired: Bool = false
        
        sut.routeTo(question: "Q1", answerCallback: { _ in  callBackWasFired = true })
        factory.answerCallbacks["Q1"]!("anything")
       
        XCTAssertTrue(callBackWasFired)
    }
    
    
    
    class NonAnimatedNavigationController: UINavigationController {
        
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            super.pushViewController(viewController, animated: false)
        }
    }
    
    
    class ViewControllerFactoryStub: ViewControllerFactory {
        
        private var stubQuestions: [String: UIViewController] = [:]
        var answerCallbacks: [String: (String) -> Void] = [:]
        
        func stub(question: String, with viewController: UIViewController) {
            stubQuestions[question] = viewController
        }
        
        func questionViewController(for question: String, answerCallback: @escaping (String) -> Void) -> UIViewController {
            answerCallbacks[question] = answerCallback
            return stubQuestions[question] ?? UIViewController()
        }
    }
}
