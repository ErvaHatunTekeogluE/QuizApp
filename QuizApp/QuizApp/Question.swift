//
//  Question.swift
//  QuizApp
//
//  Created by Erva Hatun Tekeoğlu on 11.08.2023.
//

import Foundation

enum Question<T: Hashable>: Hashable {
    case singleAnswer(T)
    case multipleAnswer(T)
    func hash(into hasher: inout Hasher) {
        
        switch self {
        case .singleAnswer(let a):
            return hasher.combine(a)
        case .multipleAnswer(let a):
            return hasher.combine(a)
        }
    }
    
    static func ==(lhs:Question<T>, rhs: Question<T>) -> Bool {
        switch (lhs, rhs) {
        case (.singleAnswer(let a), .singleAnswer(let b)):
            return a == b
        case (.multipleAnswer(let a), .multipleAnswer(let b)):
            return a == b
        default:
            return false
        }
    }
}
