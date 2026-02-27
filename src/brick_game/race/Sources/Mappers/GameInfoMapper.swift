//
//  GameInfoMapper.swift
//  Race
//
//  Created by Alena Ivanova on 25.02.2026.
//

import Foundation

struct GameInfoMapper {
    static func toGameInfo(world: RaceWorld, stats: RaceStats) -> GameInfo {
        var field = Array(
            repeating: Array(repeating: false, count: GameConstants.Field.columns),
            count: GameConstants.Field.rows
        )
        for c in world.player.occupiedCells() {
            if c.y >= 0 && c.y < GameConstants.Field.rows && c.x >= 0 && c.x < GameConstants.Field.columns {
                field[c.y][c.x] = true
            }
        }
        for enemy in world.enemies {
            for c in enemy.occupiedCells() {
                if c.y >= 0 && c.y < GameConstants.Field.rows && c.x >= 0 && c.x < GameConstants.Field.columns {
                    field[c.y][c.x] = true
                }
            }
        }

        // next - пока оставляем пустым, возможно нужно как для змейки сохранять как поле,
        // чтобы считывать завершение игры
        let next = Array(
            repeating: Array(repeating: false, count: GameConstants.Field.columns),
            count: GameConstants.Field.rows
        )

        return GameInfo(
            field: field,
            next: next,
            score: stats.score,
            highScore: stats.highScore,
            level: stats.level,
            speed: stats.speed,
            pause: stats.pause
        )
    }
}
