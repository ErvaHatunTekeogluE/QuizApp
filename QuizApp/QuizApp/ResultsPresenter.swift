//
//  ResultsPresenter.swift
//  QuizApp
//
//  Created by Erva Hatun Tekeoğlu on 17.08.2023.
//

import Foundation
import QuizEngine

struct ResultsPresenter {
    let result: Result<Question<String>, [String]>
    let correctAnswers: [Question<String>:[String]]
    let questions: [Question<String>]
    var summary: String {
        return "You got \(result.score)/\(result.answers.count) correct"
    }
    var presentableAnswers: [PresentableAnswer] {
        return questions.map { question in
            guard let userAnswers = result.answers[question],
                let correctAnswer = correctAnswers[question] else {
                fatalError("Couldn!t find correct answer for question: \(question)")
            }
            return presentableAnswers(question, userAnswers, correctAnswer)
        }
    }
    
    private func presentableAnswers(_ question: Question<String>, _ userAnswers: [String], _ correctAnswer: [String]) -> PresentableAnswer {
        
        switch question {
        case .singleAnswer(let value),.multipleAnswer(let value):
            return PresentableAnswer(question: value,
                                     answer: formattedAnswer(correctAnswer),
                                     wrongAnswer: formattedWrongAnswer(userAnswers,correctAnswer) )
        }
    }
    
    private func formattedAnswer(_ answers: [String]) -> String {
        return answers.joined(separator: ", ")
    }
    
    private func formattedWrongAnswer(_ userAnswers: [String], _ correctAnswer: [String]) -> String? {
        return userAnswers == correctAnswer ? nil : formattedAnswer(userAnswers)
    }
}
