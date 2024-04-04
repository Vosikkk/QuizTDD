//
//  QuizApp.swift
//  QuizApp
//
//  Created by Саша Восколович on 05.04.2024.
//

import SwiftUI
import QuizEngine

class QuizAppStore {
    var quiz: Quiz?
}


@main
struct QuizApp: App {
    
    let appStore: QuizAppStore = QuizAppStore()
    @StateObject var navStore: QuizNavigationStore = QuizNavigationStore()
    
    var body: some Scene {
        WindowGroup {
            QuizNavigationView(store: navStore)
                .onAppear {
                    startNewQuiz()
                }
        }
    }
    
    private func startNewQuiz() {
        let adapter = iOSSwiftUINavigationAdapter(
            // make it flexible
            navigation: navStore,
            options: options,
            correctAnswers: correctAnswers,
            playAgain: startNewQuiz
        )
        appStore.quiz = Quiz.start(questions: questions, delegate: adapter)
    }
}
