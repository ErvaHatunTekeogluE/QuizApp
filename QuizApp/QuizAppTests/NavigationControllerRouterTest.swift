//
//  NavigationControllerRouterTest.swift
//  QuizAppTests
//
//  Created by Erva Hatun Tekeoğlu on 10.08.2023.
//

import UIKit
import XCTest
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
        factory.stub(question: "Q1", with: viewController)
        factory.stub(question: "Q2", with: secondViewController)
        
        sut.routeTo(question: "Q1") { _ in }
        sut.routeTo(question: "Q2") { _ in }
        
        XCTAssertEqual(navigationController.viewControllers.count,2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    func test_routeToQuestion_presentQuestionControllerWithRightCallback() {
        var callbackWasFired = false
        
        sut.routeTo(question: "Q1", answerCallback: {_ in callbackWasFired = true})
        factory.answerCallback["Q1"]!("anything")
        XCTAssertTrue(callbackWasFired)
    }
    class ViewControllerFactoryStub: ViewControllerFactory {
        private var stubQuestions = [String: UIViewController]()
        var answerCallback = [String: (String) -> Void]()
        func stub(question: String, with viewController: UIViewController) {
            stubQuestions[question] = viewController
        }
        func questionViewController(for question: String, answerCallback: @escaping (String) -> Void) -> UIViewController {
            self.answerCallback[question] = answerCallback
            return stubQuestions[question] ?? UIViewController()
        }
        
        
    }
}
