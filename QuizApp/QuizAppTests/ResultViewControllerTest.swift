//
//  ResultViewControllerTest.swift
//  QuizAppTests
//
//  Created by Erva Hatun Tekeoğlu on 4.08.2023.
//

import Foundation
import XCTest
@testable import QuizApp

class ResultViewControllerTest: XCTestCase {
    func test_viewDidLoad_renderSummary() {
        XCTAssertEqual(makeSUT(summary: "a summary").headerLabel.text, "a summary")
    }
    
    func test_viewDidLoad_withOneAnswer_rendersAnswers() {
        XCTAssertEqual(makeSUT(summary: "a summary").tableView.numberOfRows(inSection: 0),0)
        XCTAssertEqual(makeSUT(summary: "a summary", answers: [makeAnswer()]).tableView.numberOfRows(inSection: 0),1)
    }
    
    func test_viewDidLoad_withCorrectAnswer_configuresCell() {
        let answer = makeAnswer(question: "Q1", answer: "A1")
        let sut = makeSUT(answers: [answer])
        let cell = sut.tableView.cell(at: 0) as? CorrectAnswerCell

        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.questionLabel.text,"Q1")
        XCTAssertEqual(cell?.answerLabel.text,"A1")
    }
    
    func test_viewDidLoad_withWrongAnswer_configuresCell() {
        let answer = makeAnswer(question: "Q1", answer: "A1", wrongAnswer: "wrong")
        let sut = makeSUT(answers: [answer])
        let cell = sut.tableView.cell(at: 0) as? WrongAnswerCell

        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.questionLabel.text,"Q1")
        XCTAssertEqual(cell?.correctAnswerLabel.text,"A1")
        XCTAssertEqual(cell?.wrongAnswerLabel.text,"wrong")
    }
    
//    MARK: Helpers
    
    func makeSUT(summary: String = "", answers: [PresentableAnswer] = []) -> ResultViewController {
        let sut = ResultViewController(summary,answers)
        _ = sut.view
        return sut
    }
    
    func makeAnswer(question: String = "", answer: String = "", wrongAnswer: String? = nil) -> PresentableAnswer {
        return PresentableAnswer(question: question, answer: answer, wrongAnswer: wrongAnswer)
    }
}
