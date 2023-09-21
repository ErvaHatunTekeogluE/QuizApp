//
//  NavigationControllerRouterTest.swift
//  QuizAppTests
//
//  Created by Erva Hatun Tekeoğlu on 10.08.2023.
//

import UIKit
import XCTest
import QuizEngine
@testable import QuizApp

class NavigationControllerRouterTest: XCTestCase {
    let navigationController = UINavigationController()
    let factory = ViewControllerFactoryStub()
    let multipleAnswerQuestion = Question.multipleAnswer("Q1")
    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let singleAnswerQuestion2 = Question.singleAnswer("Q2")
    lazy var sut: NavigationControllerRouter = {
        return NavigationControllerRouter(navigationController, factory: factory)
    }()
    
    func test_routeToSecondQuestion_showQuestionController() {
        let viewController = UIViewController()
        let secondViewController = UIViewController()
        factory.stub(question: singleAnswerQuestion, with: viewController)
        factory.stub(question: singleAnswerQuestion2, with: secondViewController)
        
        sut.routeTo(question: singleAnswerQuestion) { _ in }
        sut.routeTo(question: singleAnswerQuestion2) { _ in }
        
        XCTAssertEqual(navigationController.viewControllers.count,2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    func test_routeToQuestion_singleAnswer_answerCallback_progressesToNextQuestion() {
        var callbackWasFired = false
        
        sut.routeTo(question: singleAnswerQuestion, answerCallback: {_ in callbackWasFired = true})
        factory.answerCallback[singleAnswerQuestion]!(["anything"])
        XCTAssertTrue(callbackWasFired)
    }
    
    func test_routeToQuestion_singleAnswer_doesNotCconfigureViewControllerWithSubmitButton() {
        let viewController = UIViewController()
        factory.stub(question: singleAnswerQuestion, with: viewController)
        sut.routeTo(question: singleAnswerQuestion, answerCallback: {_ in })
        XCTAssertNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    func test_routeToQuestion_multipleAnswer_answerCallback_doesNotProgressToNextQuestion() {
        var callbackWasFired = false
        
        sut.routeTo(question: multipleAnswerQuestion, answerCallback: {_ in callbackWasFired = true})
        factory.answerCallback[multipleAnswerQuestion]!(["anything"])
        XCTAssertFalse(callbackWasFired)
    }
    
    func test_routeToQuestion_multipleAnswer_configuresViewControllerWithSubmitButton() {
        let viewController = UIViewController()
        factory.stub(question: multipleAnswerQuestion, with: viewController)
        sut.routeTo(question: multipleAnswerQuestion, answerCallback: {_ in })
        XCTAssertNotNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    func test_routeToQuestion_multipleAnswerSubmitButton_isDisabledWhenZeroAnswersSelected() {
        let viewController = UIViewController()
        
        factory.stub(question: multipleAnswerQuestion, with: viewController)
        sut.routeTo(question: multipleAnswerQuestion, answerCallback: {_ in })
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
        factory.answerCallback[multipleAnswerQuestion]!(["A1"])
        XCTAssertTrue(viewController.navigationItem.rightBarButtonItem!.isEnabled)
        factory.answerCallback[multipleAnswerQuestion]!([])
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
    }
    
    func test_routeToQuestion_multipleAnswerSubmitButton_progressesToNextQuestion() {
        let viewController = UIViewController()
        factory.stub(question: multipleAnswerQuestion, with: viewController)
        var callbackWasFired = false
        sut.routeTo(question: multipleAnswerQuestion, answerCallback: {_ in callbackWasFired = true})
      
        factory.answerCallback[multipleAnswerQuestion]!(["A1"])
        viewController.navigationItem.rightBarButtonItem?.simulateTap()
        XCTAssertTrue(callbackWasFired)
    }
    
    func test_routeToResult_showQResultController() {
        let viewController = UIViewController()
        let result = Result(answers: [singleAnswerQuestion: ["A1"]], score: 10)
        factory.stub(result: result, with: viewController)
        sut.routeTo(result: result)
        XCTAssertEqual(navigationController.viewControllers.count,1)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
    }
    
    func test_routeToSecondResult_showQResultController() {
        let viewController = UIViewController()
        let secondViewController = UIViewController()
        let result = Result(answers: [singleAnswerQuestion: ["A1"]], score: 10)
        let secondResult = Result(answers: [singleAnswerQuestion: ["A2"]], score: 20)
        factory.stub(result: result, with: viewController)
        factory.stub(result: secondResult, with: secondViewController)
        sut.routeTo(result: result)
        sut.routeTo(result: secondResult)
        XCTAssertEqual(navigationController.viewControllers.count,2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    // MARK: Helpers
    class ViewControllerFactoryStub: ViewControllerFactory {
        private var stubQuestions = [Question<String>: UIViewController]()
        private var stubResults = [Result<Question<String>,[String]>: UIViewController]()
        var answerCallback = [Question<String>: ([String]) -> Void]()
        
        func stub(question: Question<String>, with viewController: UIViewController) {
            stubQuestions[question] = viewController
        }
        
        func stub(result: Result<Question<String>, [String]>, with viewController: UIViewController) {
            stubResults[result] = viewController
        }
        
        func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
            self.answerCallback[question] = answerCallback
            return stubQuestions[question] ?? UIViewController()
        }
        
        func resultsViewController(for result: QuizEngine.Result<QuizApp.Question<String>, [String]>) -> UIViewController {
            return stubResults[result] ?? UIViewController()
        }
    }
}

extension UIBarButtonItem {
    func simulateTap() {
      target!.performSelector(onMainThread: action!, with: nil, waitUntilDone: true)
    }
}
