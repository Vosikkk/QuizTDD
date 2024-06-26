//
//  SceneDelegate.swift
//  QuizApp
//
//  Created by Саша Восколович on 25.02.2024.
//


import UIKit
import QuizEngine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var quiz: Quiz?
    private lazy var navigationController = UINavigationController()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        startNewQuiz()
    }
    
    private func startNewQuiz() {
        let factory = iOSUIKitViewControllerFactory(options: options, correctAnswers: correctAnswers)
        let router = NavigationControllerRouter(navigationController, factory: factory)
        quiz = Quiz.start(questions: questions, delegate: router)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

let question1 = Question.singleAnswer("What's Mike's nationality?")
let question2 = Question.multipleAnswer("What are Sasha's nationalities?")
let questions = [question1, question2]
let option1 = "Canadian"
let option2 = "American"
let option3 = "Ukrainian"
let options1 = [option1, option2, option3]


let option4 = "Canadian"
let option5 = "American"
let option6 = "Ukrainian"
let options2 = [option4, option5, option6]
let options = [question1: options1, question2: options2]

let correctAnswers = [(question1, [option3]), (question2, [option5, option6])]
