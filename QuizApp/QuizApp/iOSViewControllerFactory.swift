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
    private let correctAnswers: [Question<String>: [String]]
    init(questions: [Question<String>], options: [Question<String> : [String]], correctAnswers: [Question<String>: [String]]) {
        self.questions = questions
        self.options = options
        self.correctAnswers = correctAnswers
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
            return questionViewController(question: question, value: value, options: options, allowsMultipleSelection: false, selection: answerCallback)
        case .multipleAnswer(let value):
            return questionViewController(question: question, value: value, options: options, allowsMultipleSelection: true, selection: answerCallback)
        }
    }
    
    private func questionViewController(question: Question<String>, value: String, options:  [String], allowsMultipleSelection: Bool, selection: @escaping ([String]) -> Void) -> QuestionViewController {
        let presenter = QuestionPresenter(questions: questions, question: question)
        let controller = QuestionViewController(question: value, options: options, allowsMultipleSelection: allowsMultipleSelection, selection: selection)
        controller.title = presenter.title
        return controller
    }
    
    func resultsViewController(for result: QuizEngine.Result<Question<String>, [String]>) -> UIViewController {
        let presenter = ResultsPresenter(result: result, correctAnswers: correctAnswers, questions: questions)
        return ResultViewController(presenter.summary, [])
    }
}
