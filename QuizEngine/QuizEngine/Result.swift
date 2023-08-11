//
//  Result.swift
//  QuizEngine
//
//  Created by Erva Hatun Tekeoğlu on 10.08.2023.
//

import Foundation

public struct Result<Question:Hashable, Answer>: Hashable{
    public let answers: [Question: Answer]
    public let score: Int
    
    public init(answers: [Question: Answer], score : Int) {
        self.answers = answers
        self.score = score
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(1)
    }
    
    public static func ==(lhs: Result<Question,Answer>, rhs:  Result<Question,Answer>) -> Bool {
        return lhs.score == rhs.score
    }
}
