//
//  FlowTest.swift
//  QuizEngineTests
//
//  Created by Erva Hatun Tekeoğlu on 3.08.2023.
//

import Foundation
import XCTest
@testable import QuizEngine

class FlowTest: XCTestCase {
    let router = RouterSpy()
    
    func test_start_withNoQuestions_doesNotRouteToQuestion() {
        makeSUT(questions: []).start()
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }
    
    func test_start_withOneQuestion_routerToCorrectQuestion() {
        makeSUT(questions: ["Q1"]).start()
        
        XCTAssertEqual(router.routedQuestions,["Q1"])
    }
    
    func test_start_withOneQuestion_routerToCorrectQuestion_2() {
        makeSUT(questions: ["Q2"]).start()
        
        XCTAssertEqual(router.routedQuestions,["Q2"])
    }
    
    func test_start_withTwoQuestions_routerToFirstQuestion() {
        makeSUT(questions: ["Q1","Q2"]).start()
        
        XCTAssertEqual(router.routedQuestions,["Q1"])
    }
    
    func test_startTwice_withTwoQuestions_routesToFirstQuestionTwice() {
        let sut = makeSUT(questions: ["Q1","Q2"])
        sut.start()
        sut.start()
        
        XCTAssertEqual(router.routedQuestions,["Q1","Q1"])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestions_routesToSecondAndThirdQuestion() {
        let sut = makeSUT(questions: ["Q1","Q2","Q3"])
        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")
        
        XCTAssertEqual(router.routedQuestions,["Q1","Q2","Q3"])
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestion_doesNotRouteToAnotherQuestion() {
        makeSUT(questions: ["Q1"]).start()
        router.answerCallback("A1")
        XCTAssertEqual(router.routedQuestions,["Q1"])
    }
    
    func test_start_withNoQuestions_routesToResult() {
        makeSUT(questions: []).start()
        XCTAssertEqual(router.routedResult, [:])
    }
    
    func test_start_withOneQuestion_doesNotRouteToResult() {
        makeSUT(questions: ["Q1"]).start()
        XCTAssertNil(router.routedResult)
    }
    
    func test_startAnswerFirstQuestion_withTwoQuestions_doesNotRouteToResult() {
        let sut = makeSUT(questions: ["Q1","Q2"])
        sut.start()
        router.answerCallback("A1")
        XCTAssertNil(router.routedResult)
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_routesToResult() {
        let sut = makeSUT(questions: ["Q1","Q2"])
        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")
        XCTAssertEqual(router.routedResult, ["Q1": "A1", "Q2": "A2"])
    }
    
    func makeSUT(questions: [String]) -> Flow {
        return Flow(router: router, questions: questions)
    }
    
    class RouterSpy: Router {
        var routedResult: [String:String]? = nil
        var routedQuestions: [String] = []
        var answerCallback: Router.AnswerCallback = {_ in}
        
        func routeTo(question: String, answerCallback: @escaping Router.AnswerCallback) {
            routedQuestions.append(question)
            self.answerCallback = answerCallback
        }
        
        func routeTo(result: [String : String]) {
            self.routedResult = result
        }
    }
}
