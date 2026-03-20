//
//  RaceFSMTests.swift
//  BrickGame
//
//  Created by Alena Ivanova on 17.03.2026.
//

import XCTest
@testable import RaceSwiftLib
import TetrisCLib

final class RaceFSMTests: XCTestCase {
        
    func testActionInitWithValidUserAction() {
        let validActions: [(UserAction_t, Action)] = [
            (UserAction_t(10), .start),
            (UserAction_t(11), .pause),
            (UserAction_t(12), .terminate),
            (UserAction_t(13), .left),
            (UserAction_t(14), .right),
            (UserAction_t(15), .up),
            (UserAction_t(16), .down),
            (UserAction_t(17), .action),
            (UserAction_t(18), .none)
        ]
        
        for (cAction, expectedAction) in validActions {
            let action = Action(cAction)
            XCTAssertEqual(action, expectedAction, "Action rawValue \(cAction.rawValue) должен конвертироваться в \(expectedAction)")
        }
    }
    
    func testActionInitWithInvalidUserAction() {
        let invalidRawValues: [UserAction_t] = [
            UserAction_t(0),
            UserAction_t(999),
            UserAction_t(100)
        ]
        
        for cAction in invalidRawValues {
            let action = Action(cAction)
            XCTAssertEqual(action, .none, "Невалидный rawValue \(cAction.rawValue) должен конвертироваться в .none")
        }
    }

    func testBeginStateWithStartAction() {
        let currentState: RaceGameState = .begin
        let action: Action = .start
        
        let nextState = RaceFSM.nextState(current: currentState, action: action)
        
        XCTAssertEqual(nextState, .running, "Из .begin с .start должен переходить в .running")
    }
    
    func testBeginStateWithNonStartActions() {
        let currentState: RaceGameState = .begin
        let actions: [Action] = [.pause, .terminate, .left, .right, .up, .down, .action, .none]
        
        for action in actions {
            let nextState = RaceFSM.nextState(current: currentState, action: action)
            
            XCTAssertEqual(nextState, .begin, "Из .begin с \(action) должен оставаться в .begin")
        }
    }

    func testRunningStateWithPauseAction() {
        let currentState: RaceGameState = .running
        let action: Action = .pause
        
        let nextState = RaceFSM.nextState(current: currentState, action: action)
        
        XCTAssertEqual(nextState, .break, "Из .running с .pause должен переходить в .break")
    }
    
    func testRunningStateWithTerminateAction() {
        let currentState: RaceGameState = .running
        let action: Action = .terminate
        
        let nextState = RaceFSM.nextState(current: currentState, action: action)
        
        XCTAssertEqual(nextState, .end, "Из .running с .terminate должен переходить в .end")
    }
    
    func testRunningStateWithLeftAction() {
        let currentState: RaceGameState = .running
        let action: Action = .left
        
        let nextState = RaceFSM.nextState(current: currentState, action: action)
        
        XCTAssertEqual(nextState, .movingLeft, "Из .running с .left должен переходить в .movingLeft")
    }
    
    func testRunningStateWithRightAction() {
        let currentState: RaceGameState = .running
        let action: Action = .right
        
        let nextState = RaceFSM.nextState(current: currentState, action: action)
        
        XCTAssertEqual(nextState, .movingRight, "Из .running с .right должен переходить в .movingRight")
    }
    
    func testRunningStateWithOtherActions() {
        let currentState: RaceGameState = .running
        let actions: [Action] = [.start, .up, .down, .action, .none]
        
        for action in actions {
            let nextState = RaceFSM.nextState(current: currentState, action: action)
            
            XCTAssertEqual(nextState, .running, "Из .running с \(action) должен оставаться в .running")
        }
    }

    func testMovingStatesRemainSameForAnyAction() {
        let movingStates: [RaceGameState] = [.movingLeft, .movingRight]
        let allActions: [Action] = [.start, .pause, .terminate, .left, .right, .up, .down, .action, .none]
        
        for state in movingStates {
            for action in allActions {
                let nextState = RaceFSM.nextState(current: state, action: action)
                
                XCTAssertEqual(nextState, state, "Из \(state) с \(action) должен оставаться в \(state)")
            }
        }
    }

    func testBreakStateWithPauseAction() {
        let currentState: RaceGameState = .break
        let action: Action = .pause
        
        let nextState = RaceFSM.nextState(current: currentState, action: action)
        
        XCTAssertEqual(nextState, .running, "Из .break с .pause должен переходить в .running")
    }
    
    func testBreakStateWithTerminateAction() {
        let currentState: RaceGameState = .break
        let action: Action = .terminate
        
        let nextState = RaceFSM.nextState(current: currentState, action: action)
        
        XCTAssertEqual(nextState, .end, "Из .break с .terminate должен переходить в .end")
    }
    
    func testBreakStateWithOtherActions() {
        let currentState: RaceGameState = .break
        let actions: [Action] = [.start, .left, .right, .up, .down, .action, .none]
        
        for action in actions {
            let nextState = RaceFSM.nextState(current: currentState, action: action)
            
            XCTAssertEqual(nextState, .break, "Из .break с \(action) должен оставаться в .break")
        }
    }

    func testEndStateWithStartAction() {
        let currentState: RaceGameState = .end
        let action: Action = .start
        
        let nextState = RaceFSM.nextState(current: currentState, action: action)
        
        XCTAssertEqual(nextState, .running, "Из .end с .start должен переходить в .running")
    }
    
    func testEndStateWithTerminateAction() {
        let currentState: RaceGameState = .end
        let action: Action = .terminate
        
        let nextState = RaceFSM.nextState(current: currentState, action: action)
        
        XCTAssertEqual(nextState, .exit, "Из .end с .terminate должен переходить в .exit")
    }
    
    func testEndStateWithOtherActions() {
        let currentState: RaceGameState = .end
        let actions: [Action] = [.pause, .left, .right, .up, .down, .action, .none]
        
        for action in actions {
            let nextState = RaceFSM.nextState(current: currentState, action: action)
            
            XCTAssertEqual(nextState, .end, "Из .end с \(action) должен оставаться в .end")
        }
    }
        
    func testExitStateRemainsExitForActions() {
        let currentState: RaceGameState = .exit
        let allActions: [Action] = [.pause, .terminate, .left, .right, .up, .down, .action, .none]
        
        for action in allActions {
            let nextState = RaceFSM.nextState(current: currentState, action: action)
            
            XCTAssertEqual(nextState, .exit, "Из .exit с \(action) должен оставаться в .exit")
        }
    }
    
    func testExitStateChangesExitForStart() {
        let currentState: RaceGameState = .exit
        let startAction: Action = .start
        let nextState = RaceFSM.nextState(current: currentState, action: startAction)
        XCTAssertEqual(nextState, .running, "Из .exit с \(startAction) должен измениться в .running")

    }
        
    func testFullGameFlowSequence() {
        var state: RaceGameState = .begin
        let actions: [(Action, RaceGameState)] = [
            (.start, .running),
            (.left, .movingLeft),
            (.none, .movingLeft)
        ]
        
        for (action, expectedState) in actions {
            state = RaceFSM.nextState(current: state, action: action)
            
            XCTAssertEqual(state, expectedState, "После \(action) должно быть \(expectedState)")
        }
    }
    
    func testInvalidTransitions() {
        var state = RaceFSM.nextState(current: .running, action: .start)
        
        XCTAssertEqual(state, .running, "Из .running с .start нельзя перейти")
        
        state = RaceFSM.nextState(current: .break, action: .left)
        
        XCTAssertEqual(state, .break, "Из .break с .left нельзя перейти")
        
        state = RaceFSM.nextState(current: .end, action: .pause)
        
        XCTAssertEqual(state, .end, "Из .end с .pause нельзя перейти")
    }
    
    func testActionRawValuesConsistency() {
        XCTAssertEqual(Action.start.rawValue, 10)
        XCTAssertEqual(Action.pause.rawValue, 11)
        XCTAssertEqual(Action.terminate.rawValue, 12)
        XCTAssertEqual(Action.left.rawValue, 13)
        XCTAssertEqual(Action.right.rawValue, 14)
        XCTAssertEqual(Action.up.rawValue, 15)
        XCTAssertEqual(Action.down.rawValue, 16)
        XCTAssertEqual(Action.action.rawValue, 17)
        XCTAssertEqual(Action.none.rawValue, 18)
    }
}
