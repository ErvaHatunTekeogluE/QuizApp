//
//  iOSViewControllerFactory.swift
//  QuizApp
//
//  Created by Erva Hatun Tekeoğlu on 11.08.2023.
//

import UIKit
import QuizEngine

class iOSViewControllerFactory: ViewControllerFactory {
    private let options: [Question<String>: [String]]
    
    init(options: [Question<String> : [String]]) {
        self.options = options
    }
    
    func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        switch question {
        case .singleAnswer(let value):
            return QuestionViewController(question: value, options: options[question]!, selection: answerCallback)
        default:
            return UIViewController()
        }
        
    }
    
    func resultsViewController(for result: QuizEngine.Result<Question<String>, [String]>) -> UIViewController {
        return QuestionViewController()
    }
}
