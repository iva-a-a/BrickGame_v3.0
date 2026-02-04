//
//  RaceGame.swift
//  Race
//
//  Created by Alena Ivanova on 15.01.2026.
//



final class RaceGame {
  private var world = RaceWorld(
    playerCar: Car(lane: GameConstants.Car.startLane, topY: GameConstants.Car.startTopY)
  )
  private var info = GameInfo()
  private var fsm = RaceFSM()
  private var engine = RaceGameplay()

  func userInput(action: Action, hold: Bool) {
    // Up (hold) controls acceleration in running
    if fsm.state == .running && action == .up {
      world.isAccelerating = hold
    }
    if fsm.state == .running && action != .up && action != .none {
      // отпускание up можно обрабатывать отдельно; здесь просто пример
      // world.isAccelerating = false
    }

    // FSM transitions (pause/start/terminate/left/right)
    fsm.handle(action: action, hold: hold)
  }

  func updateCurrentState() -> GameInfo {
    engine.tick(world: &world, info: &info, fsm: &fsm)
    return info
  }
}

