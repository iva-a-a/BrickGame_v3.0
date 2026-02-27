//
//  RaceController.swift
//  Race
//
//  Created by Alena Ivanova on 12.01.2026.
//

import Foundation
import TetrisCLib

final class RaceController {
    var world = RaceWorld()
    var stats = RaceStats()
    var state: RaceGameState = .begin
    
    private var input = InputState()
    
    private var tick: Int = 0
    private var fallCounter: Int = 0
    private var spawnCounter: Int = 0

    func setInput(_ action: Action, hold: Bool) {
        input.action = action
        input.hold = hold
    }

    func update() -> (RaceWorld, RaceStats) {
        tick += 1

        // 1) FSM: определяем новое состояние по текущему action
        state = RaceFSM.nextState(current: state, action: input.action)
        switch state {
        case .begin:
            // ждём start
            break
        case .generation:
            stats.highScore = HighScoreStorage.get()
            state = .running
        case .break:
            stats.pause = true
        case .end:
            RaceGameplay.changeHighScore(score: stats.score, highScore: &stats.highScore)
            HighScoreStorage.save(highScore: stats.highScore)
        case .exit:
            break
        case .running, .movingLeft, .movingRight:
            stats.pause = false

            // 3) Движение игрока (1 клетка)
            // Если hold=true, можно разрешать движение каждый тик при left/right.
            // Если hold=false, то двигаем только когда action left/right.
            if input.hold || input.action == .left || input.action == .right {
                RaceGameplay.movePlayer(world: &world, action: input.action)
            }

            // 4) Сдвиг врагов и спавн синхронизируем по speed (мс)
            // Здесь предполагаем, что update() вызывается с фиксированным периодом, например 50мс.
            // Тогда "speed" можно трактовать как "каждые N тиков".
            // Чтобы не путаться, сделаем tick-based: fallPeriodTicks вычисляется из уровня.
            let fallPeriodTicks = max(1, (stats.speed / 100)) // пример: 1000мс -> 10 тиков, если update ~100мс
            fallCounter += 1

            if fallCounter >= fallPeriodTicks {
                fallCounter = 0

                // враги вниз + очки
                RaceGameplay.moveEnemies(world: &world, score: &stats.score)

                // спавн не каждый раз: например, раз в 2 падения (потом можно усложнить)
                spawnCounter += 1
                if spawnCounter >= 2 {
                    _ = RaceGameplay.trySpawnEnemy(world: &world)
                    spawnCounter = 0
                }

                // коллизия
                if RaceGameplay.hasCollision(world: world) {
                    state = .end
                }

                // уровень/скорость
                let oldLevel = stats.level
                RaceGameplay.increaseLevel(score: stats.score, level: &stats.level)
                if stats.level != oldLevel {
                    RaceGameplay.updateSpeed(level: stats.level, speed: &stats.speed)
                }
            }
        }
        return (world, stats)
    }
}
