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
    func test_routeToQuestion_presentQuestionController() {
        let navigationController = UINavigationController()
        let sut = NavigationControllerRouter(navigationController)
        sut.routeTo(question: "Q1") { _ in }
        XCTAssertEqual(navigationController.viewControllers.count, 1)
    }
    
    func test_routeToQuestionTwice_presentQuestionController() {
        let navigationController = UINavigationController()
        let sut = NavigationControllerRouter(navigationController)
        sut.routeTo(question: "Q1") { _ in }
        sut.routeTo(question: "Q2") { _ in }
        XCTAssertEqual(navigationController.viewControllers.count, 2)
    }
}
