//
//  NavigationControllerRouter.swift
//  QuizApp
//
//  Created by Саша Восколович on 02.03.2024.
//

import UIKit
import QuizEngine

final class NavigationControllerRouter: QuizDelegate {
    
    private let navigationController: UINavigationController
    private let factory: ViewControllerFactory
    
    init(_ navigationController: UINavigationController, factory: ViewControllerFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    
    func answer(for question: Question<String>, completion: @escaping ([String]) -> Void) {
        switch question {
        case .singleAnswer:
            show(factory.questionViewController(for: question, answerCallback: completion))
        case .multipleAnswer:
            let button = UIBarButtonItem(title: "Submit", style: .done, target: nil, action: nil)
            let buttonController = SubmitButtonController(with: button, and: completion)
            let controller = factory.questionViewController(for: question, answerCallback: { selection in
                buttonController.update(selection)
            })
            
            controller.navigationItem.rightBarButtonItem = button
            show(controller)
        }
    }
    
    func didCompleteQuiz(withAnswers answers: [(question: Question<String>, answer: [String])]) {
        show(factory.resultsViewController(for: answers))
    }
    
    private func show(_ viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
}

private class SubmitButtonController {
    
    let button: UIBarButtonItem
    let callback: ([String]) -> Void
    private var model: [String] = []
    
    init(with button: UIBarButtonItem, and callback: @escaping ([String]) -> Void) {
        self.button = button
        self.callback = callback
        self.setup()
    }
    
    
    private func setup() {
        button.target = self
        button.action = #selector(fireCallback)
        updateButtonState()
    }
    
    func update(_ model: [String]) {
        self.model = model
        updateButtonState()
    }
    
    @objc private func fireCallback() {
        callback(model)
    }
    
    private func updateButtonState() {
        button.isEnabled = model.count > 0
    }
}
