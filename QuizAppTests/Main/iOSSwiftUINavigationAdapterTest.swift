//
//  iOSSwiftUIViewControllerFactoryTest.swift
//  QuizAppTests
//
//  Created by Саша Восколович on 22.03.2024.
//

import SwiftUI
import XCTest
import QuizEngine
@testable import QuizApp


final class iOSSwiftUINavigationAdapterTest: XCTestCase {

    func test_questionViewController_singleAnswer_createsViewControllerWithTitle() throws {
        let presenter = QuestionPresenter(
            questions: [singleAnswerQuestion, multipleAnswerQuestion],
            question: singleAnswerQuestion
        )
        let view = try XCTUnwrap(makeSingleAnswerQuestion())
        XCTAssertEqual(view.title, presenter.title)
    }
    
    func test_questionViewController_singleAnswer_createsViewControllerWithQuestion() throws {
        let view = try XCTUnwrap(makeSingleAnswerQuestion())
        XCTAssertEqual(view.question, "Q1")
    }
    
    func test_questionViewController_singleAnswer_createsViewControllerWithOptions() throws {
        let view = try XCTUnwrap(makeSingleAnswerQuestion())
        XCTAssertEqual(view.options, options[singleAnswerQuestion])
    }
    
    
    func test_questionViewController_singleAnswer_createsViewControllerWithAnswerCallback() throws {
        var answers: [[String]] = []
        let view = try XCTUnwrap(makeSingleAnswerQuestion(answerCallback: { answers.append($0) }))
        XCTAssertEqual(answers, [])
        
        view.selection(view.options[0])
        XCTAssertEqual(answers, [[view.options[0]]])
        
        view.selection(view.options[1])
        XCTAssertEqual(answers, [[view.options[0]], [view.options[1]]])
    }
    
    
    func test_questionViewController_multipleAnswer_createsViewControllerWithTitle() throws {
        
        let presenter = QuestionPresenter(
            questions: [singleAnswerQuestion, multipleAnswerQuestion],
            question: multipleAnswerQuestion
        )
        let view = try XCTUnwrap(makeMultipleAnswerQuestion())
        XCTAssertEqual(view.title, presenter.title)
    }
    
    func test_questionViewController_multipleAnswer_createsViewControllerWithQuestion() throws {
        let view = try XCTUnwrap(makeMultipleAnswerQuestion())
        XCTAssertEqual(view.question, "Q2")
    }
    
    func test_questionViewController_multipleAnswer_createsViewControllerWithOptions() throws {
        let view = try XCTUnwrap(makeMultipleAnswerQuestion())

        XCTAssertEqual(view.store.options.map(\.text), options[multipleAnswerQuestion])
    }
   
    func test_resultViewController_createsControllerWithSummary() throws {
        let (view, presenter) =  try XCTUnwrap(makeResults())
        XCTAssertEqual(view.summary, presenter.summary)
    }
    
    func test_resultViewController_createsControllerWithPresentableAnswers() throws {
        let (view, presenter) =  try XCTUnwrap(makeResults())
        XCTAssertEqual(view.answers, presenter.presentableAnswers)
    }
    
    func test_resultViewController_createsControllerWithTitle() throws {
        let (view, presenter) =  try XCTUnwrap(makeResults())
        XCTAssertEqual(view.title, presenter.title)
    }
    
    
    func test_resultViewController_createsControllerWithPlayAgainAction() throws {
        var playAgainCount: Int = 0
        
        let (view, _) =  try XCTUnwrap(makeResults(playAgain: { playAgainCount += 1 }))
        XCTAssertEqual(playAgainCount, 0)
        
        view.playAgain()
        XCTAssertEqual(playAgainCount, 1)
        
        view.playAgain()
        XCTAssertEqual(playAgainCount, 2)
    }
    
    
    func test_answerForQuestion_replacesCurrentView() {
        let (sut, navigation) = makeSUT()
        
        sut.answer(for: singleAnswerQuestion) { _ in }
       
        XCTAssertNotNil(navigation.singleCurrentView)
        
        sut.answer(for: multipleAnswerQuestion) { _ in }
      
        XCTAssertNotNil(navigation.multipleCurrentView)
    }
    
    
    func test_didCompleteQuiz_replacesCurrentView() {
        let (sut, navigation) = makeSUT()
        
        sut.didCompleteQuiz(withAnswers: correctAnswers)
       
        XCTAssertNotNil(navigation.resultCurrentView)
        
        sut.didCompleteQuiz(withAnswers: correctAnswers)
       
        XCTAssertNotNil(navigation.resultCurrentView)
    }
    
    
    func test_publishesNavigationChanges() {
        let (sut, navigation) = makeSUT()
        
        var navigationChangesCount: Int = 0
        
        let cancellable = navigation.objectWillChange.sink { navigationChangesCount += 1 }
        
        sut.answer(for: singleAnswerQuestion) { _ in }
        XCTAssertEqual(navigationChangesCount, 1)
        
        sut.answer(for: multipleAnswerQuestion) { _ in }
        XCTAssertEqual(navigationChangesCount, 2)
        
        sut.didCompleteQuiz(withAnswers: correctAnswers)
        XCTAssertEqual(navigationChangesCount, 3)
        
        cancellable.cancel()
    }
    
    
    // MARK: - Helpers
    
    
    private var singleAnswerQuestion: Question<String> { .singleAnswer("Q1") }
    private var multipleAnswerQuestion: Question<String> { .multipleAnswer("Q2") }
    
    private var questions: [Question<String>] {
        [singleAnswerQuestion, multipleAnswerQuestion]
    }
    
    private var options: [Question<String>: [String]] {
        [singleAnswerQuestion: ["A1", "A2", "A3"], multipleAnswerQuestion: ["A4", "A5", "A6"]]
    }
    
    private var correctAnswers: [(Question<String>, [String])] {
        [(singleAnswerQuestion, ["A1"]), (multipleAnswerQuestion, ["A4, A5"])]
    }
    
    private func makeSUT(
        playAgain: @escaping () -> Void = {}
    ) -> (iOSSwiftUINavigationAdapter, QuizNavigationStore)  {
        
        let navigation = QuizNavigationStore()
        
        let sut = iOSSwiftUINavigationAdapter(
            navigation: navigation,
            options: options,
            correctAnswers: correctAnswers,
            playAgain: playAgain
        )
        return (sut, navigation)
    }
    
    private func makeSingleAnswerQuestion(
        answerCallback: @escaping ([String]) -> Void = { _ in }
    ) -> SingleAnswerQuestion? {
        
        let (sut, navigation) = makeSUT()
        sut.answer(for: singleAnswerQuestion, completion: answerCallback)
        return navigation.singleCurrentView
    }

    
    private func makeMultipleAnswerQuestion(
        answerCallback: @escaping ([String]) -> Void = { _ in }
    ) -> MultipleAnswerQuestion? {
        
        let (sut, navigation) = makeSUT()
        sut.answer(for: multipleAnswerQuestion, completion: answerCallback)

        return  navigation.multipleCurrentView
    }

    
    private func makeResults(
        playAgain: @escaping () -> Void = {}
    ) -> (view: ResultView, presenter: ResultsPresenter)? {
        
        let (sut, navigation) = makeSUT(playAgain: playAgain)

        sut.didCompleteQuiz(withAnswers: correctAnswers)
        let presenter = ResultsPresenter(
            userAnswers: correctAnswers,
            correctAnswers: correctAnswers,
            scorer: BasicScore.score
        )
        
        let view = navigation.resultCurrentView
        
        return view.map { ($0, presenter) }
    }
}

private extension QuizNavigationStore {
    var singleCurrentView: SingleAnswerQuestion? {
        if case let .single(view) = currentView { return view }
        return nil
    }
    
    var multipleCurrentView: MultipleAnswerQuestion? {
        if case let .multiple(view) = currentView { return view }
        return nil
    }
    
    var resultCurrentView:  ResultView? {
        if case let .result(view) = currentView { return view }
        return nil
    }
}
