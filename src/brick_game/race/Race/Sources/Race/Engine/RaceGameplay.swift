//
//  RaceGameplay.swift
//  Race
//
//  Created by Alena Ivanova on 25.02.2026.
//

import Foundation

struct RaceGameplay {
    static func movePlayer(world: inout RaceWorld, action: Action) {
        switch action {
        case .left:
            if world.player.upLeftPosition.x > 0 {
                world.player.upLeftPosition.x -= 1
            }
        case .right:
            if world.player.upLeftPosition.x < GameConstants.Field.columns - CarShapes.size.w {
                world.player.upLeftPosition.x += 1
            }
        default:
            break
        }
    }
    
    static func moveEnemies(world: inout RaceWorld, score: inout Int) {
        for i in world.enemies.indices {
            world.enemies[i].upLeftPosition.y += 1
        }
        
        let before = world.enemies.count
        world.enemies.removeAll { $0.upLeftPosition.y >= GameConstants.Field.rows }
        let removed = before - world.enemies.count
        
        if removed > 0 {
            score += removed * GameConstants.Gameplay.overtakePoints
        }
    }

    static func trySpawnEnemy(world: inout RaceWorld) -> Bool {
        let maxX = GameConstants.Field.columns - CarShapes.size.w
        let startY = -CarShapes.size.h + 1

        if world.enemies.contains(where: { $0.upLeftPosition.y <= GameConstants.Gameplay.minTopGapY }) {
            return false
        }

        let enemyCells = Set(world.enemies.flatMap { $0.occupiedCells() })

        let topEnemies = world.enemies.filter { $0.upLeftPosition.y <= 6 }

        for _ in 0..<GameConstants.Gameplay.maxSpawnAttempts {
            let x = Int.random(in: 0...maxX)
            let enemy = Car(upLeftPosition: Coordinate(x: x, y: startY), body: CarShapes.enemy)
            if enemy.occupiedCells().contains(where: { enemyCells.contains($0) }) {
                continue
            }
            if topEnemies.contains(where: { abs($0.upLeftPosition.x - x) < GameConstants.Gameplay.minGapX }) {
                continue
            }

            world.enemies.append(enemy)
            return true
        }

        return false
    }
    
    static func hasCollision(world: RaceWorld) -> Bool {
        let playerCells = Set(world.player.occupiedCells())
        let enemyCells = Set(world.enemies.flatMap { $0.occupiedCells() })
        return !playerCells.isDisjoint(with: enemyCells)
    }
    
    static func changeHighScore(score: Int, highScore: inout Int) {
        if score > highScore { highScore = score }
    }
    
    static func increaseLevel(score: Int, level: inout Int) {
        let maxLevel = GameConstants.Gameplay.maxLevel
        let step = GameConstants.Gameplay.scoreToLevelUp
        let calculatedLevel = min(maxLevel, 1 + score / step)
        if calculatedLevel > level {
            level = calculatedLevel
        }
    }

    static func updateSpeed(level: Int, speed: inout Int) {
        let base = GameConstants.Gameplay.baseSpeedMs
        let minS = GameConstants.Gameplay.minSpeedMs
        let step = GameConstants.Gameplay.speedStepMs
        let newSpeed = max(minS, base - (level - 1) * step)
        speed = newSpeed
    }
}

