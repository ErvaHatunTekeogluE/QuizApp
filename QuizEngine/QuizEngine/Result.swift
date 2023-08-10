//
//  Result.swift
//  QuizEngine
//
//  Created by Erva Hatun Tekeoğlu on 10.08.2023.
//

import Foundation

public struct Result<Question:Hashable, Answer> {
    public let answers: [Question: Answer]
    public let score: Int
}
