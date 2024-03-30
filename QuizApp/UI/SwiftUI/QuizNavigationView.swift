//
//  QuizNavigationView.swift
//  QuizApp
//
//  Created by Саша Восколович on 30.03.2024.
//

import SwiftUI



class QuizNavigationStore: ObservableObject {
    
    @Published var currentView: CurrentView?
    
    enum CurrentView {
        case single(SingleAnswerQuestion)
        case multiple(MultipleAnswerQuestion)
        case result(ResultView)
    }
    
    var view: AnyView {
        switch currentView {
        case .single(let view):
             convert(from: view)
        case .multiple(let view):
             convert(from: view)
        case .result(let view):
             convert(from: view)
        default:
             convert(from: EmptyView())
        }
    }
    
    private func convert(from view: any View) -> AnyView {
         AnyView(view)
    }
}


struct QuizNavigationView: View {
    
    @ObservedObject var store: QuizNavigationStore
    
    var body: some View {
        store.view
            .transition(
                AnyTransition
                    .opacity
                    .combined(with: .rollLeft)
            )
            .id(UUID())
    }
}

extension AnyTransition {
    static let rollRight: AnyTransition = .asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing))
    static let rollLeft: AnyTransition = .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
}

