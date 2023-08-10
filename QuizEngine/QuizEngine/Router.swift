//
//  Router.swift
//  QuizEngine
//
//  Created by Erva Hatun Tekeoğlu on 10.08.2023.
//

import Foundation

public protocol Router {
    associatedtype Question: Hashable
    associatedtype Answer
    
    func routeTo(question: Question, answerCallback: @escaping (Answer) -> Void)
    func routeTo(result: Result<Question, Answer>)
}
