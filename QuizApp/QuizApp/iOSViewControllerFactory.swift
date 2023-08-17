//
//  iOSViewControllerFactory.swift
//  QuizApp
//
//  Created by Erva Hatun Tekeoğlu on 11.08.2023.
//

import UIKit
import QuizEngine

class iOSViewControllerFactory: ViewControllerFactory {
    private let questions: [Question<String>]
    private let options: [Question<String>: [String]]
    
    init(questions: [Question<String>], options: [Question<String> : [String]]) {
        self.questions = questions
        self.options = options
    }
    
    func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        guard let options = options[question] else {
            fatalError("Couldn't find options for question \(question)")
        }
        return questionViewController(for: question, options: options, answerCallback: answerCallback)
    }
    
    private func questionViewController(for question: Question<String>, options: [String], answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        switch question {
        case .singleAnswer(let value):
            let controller = questionViewController(question: question, value: value, options: options, selection: answerCallback)
            return controller
        case .multipleAnswer(let value):
            let controller = questionViewController(question: question, value: value, options: options, selection: answerCallback)
            _ = controller.view
            controller.tableView.allowsMultipleSelection = true
            return controller
        }
    }
    
    private func questionViewController(question: Question<String>, value: String, options:  [String], selection: @escaping ([String]) -> Void) -> QuestionViewController {
        let presenter = QuestionPresenter(questions: questions, question: question)
        let controller = QuestionViewController(question: value, options: options, selection: selection)
        controller.title = presenter.title
        return controller
    }
    
    func resultsViewController(for result: QuizEngine.Result<Question<String>, [String]>) -> UIViewController {
        return QuestionViewController()
    }
}
