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
    lazy var sut: NavigationControllerRouter = {
        return NavigationControllerRouter(navigationController, factory: factory)
    }()
    
    func test_routeToSecondQuestion_showQuestionController() {
        let viewController = UIViewController()
        let secondViewController = UIViewController()
        factory.stub(question: Question.singleAnswer("Q1"), with: viewController)
        factory.stub(question: Question.singleAnswer("Q2"), with: secondViewController)
        
        sut.routeTo(question: Question.singleAnswer("Q1")) { _ in }
        sut.routeTo(question: Question.singleAnswer("Q2")) { _ in }
        
        XCTAssertEqual(navigationController.viewControllers.count,2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    func test_routeToQuestion_presentQuestionControllerWithRightCallback() {
        var callbackWasFired = false
        
        sut.routeTo(question: Question.singleAnswer("Q1"), answerCallback: {_ in callbackWasFired = true})
        factory.answerCallback[Question.singleAnswer("Q1")]!("anything")
        XCTAssertTrue(callbackWasFired)
    }
    
    func test_routeToResult_showQResultController() {
        let viewController = UIViewController()
        let result = Result(answers: [Question.singleAnswer("Q1"): "A1"], score: 10)
        factory.stub(result: result, with: viewController)
        sut.routeTo(result: result)
        XCTAssertEqual(navigationController.viewControllers.count,1)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
    }
    
    func test_routeToSecondResult_showQResultController() {
        let viewController = UIViewController()
        let secondViewController = UIViewController()
        let result = Result(answers: [Question.singleAnswer("Q1"): "A1"], score: 10)
        let secondResult = Result(answers: [Question.singleAnswer("Q2"): "A2"], score: 20)
        factory.stub(result: result, with: viewController)
        factory.stub(result: secondResult, with: secondViewController)
        sut.routeTo(result: result)
        sut.routeTo(result: secondResult)
        XCTAssertEqual(navigationController.viewControllers.count,2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    class ViewControllerFactoryStub: ViewControllerFactory {
        
        
        private var stubQuestions = [Question<String>: UIViewController]()
        private var stubResults = [Result<Question<String>,String>: UIViewController]()
        var answerCallback = [Question<String>: (String) -> Void]()
        
        func stub(question: Question<String>, with viewController: UIViewController) {
            stubQuestions[question] = viewController
        }
        
        func stub(result: Result<Question<String>, String>, with viewController: UIViewController) {
            stubResults[result] = viewController
        }
        
        func questionViewController(for question: Question<String>, answerCallback: @escaping (String) -> Void) -> UIViewController {
            self.answerCallback[question] = answerCallback
            return stubQuestions[question] ?? UIViewController()
        }
        
        func resultsViewController(for result: QuizEngine.Result<QuizApp.Question<String>, String>) -> UIViewController {
            return stubResults[result] ?? UIViewController()
        }
    }
}

//extension Result: Hashable {
//    public init(answers: [Question: Answer], score : Int) {
//        self.answers = answers
//        self.score = score
//    }
//
//    public init() {
//        self.answers = [:]
//        self.score = 0
//    }
//
//    public func hash(into hasher: inout Hasher) {
//        return hasher.combine(1)
//    }
//
//    public static func ==(lhs: Result<Question,Answer>, rhs:  Result<Question,Answer>) -> Bool {
//        return lhs.score == rhs.score
//    }
//}
