//
//  ViewControllerFactory.swift
//  QuizApp
//
//  Created by Erva Hatun Tekeoğlu on 11.08.2023.
//

import UIKit
import QuizEngine

protocol ViewControllerFactory {
    func questionViewController(for question: Question<String>, answerCallback: @escaping (String) -> Void) -> UIViewController
    func resultsViewController(for result: Result<Question<String>, String>) -> UIViewController
}
