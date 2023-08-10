//
//  RouterSpy.swift
//  QuizEngineTests
//
//  Created by Erva Hatun Tekeoğlu on 10.08.2023.
//

import Foundation
import QuizEngine

public class RouterSpy: Router {
    var routedResult: Result<String,String>? = nil
    var routedQuestions: [String] = []
    var answerCallback: (String) -> Void = {_ in}
    
    public func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
        routedQuestions.append(question)
        self.answerCallback = answerCallback
    }
    
    public func routeTo(result: Result<String, String>) {
        self.routedResult = result
    }
}
