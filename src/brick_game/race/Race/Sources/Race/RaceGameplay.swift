//
//  RaceGameplay.swift
//  Race
//
//  Created by Alena Ivanova on 12.01.2026.
//

struct RaceGameplay {
    func isCollision(world: RaceWorld) -> Bool {
        let playerTop = world.playerCar.topY
        let playerBottom = world.playerCar.topY + GameConstants.Car.height - 1
        for rivalCar in world.rivalCars where rivalCar.lane == world.playerCar.lane {
            let rivalTop = rivalCar.topY
            let rivalBottom = rivalCar.topY + GameConstants.Car.height - 1
            if !(rivalBottom < playerTop || rivalTop > playerBottom) {
                return true
            }
        }
        return false
    }
    
    mutating func moveCar(state: RaceGameState, world: inout RaceWorld) {
        switch state {
        case .movingLeft: world.playerCar.lane = max(GameConstants.Car.minLane, world.playerCar.lane - 1)
        case .movingRight: world.playerCar.lane = min(GameConstants.Car.maxLane, world.playerCar.lane + 1)
        default: break
        }
    }
    
    mutating func spawnRival(world: inout RaceWorld) {
        let lanes = Array(GameConstants.Car.minLane...GameConstants.Car.maxLane)
        let available = lanes.filter { canSpawn(world: world, in: $0) }
        guard let selected = available.randomElement() else {
            return
        }
        world.rivalCars.append(Car(lane: selected, topY: 1 - GameConstants.Car.height))
    }
    
    func canSpawn(world: RaceWorld, in lane: Int) -> Bool {
        let h = GameConstants.Car.height
        let newTopY = 1 - h
        let newBottomY = newTopY + h - 1
        
        func isNeighborLane(_ a: Int, _ b: Int) -> Bool {
            abs(a - b) == 1
        }
        
        for r in world.rivalCars {
            if r.lane != lane && !isNeighborLane(r.lane, lane) {
                continue
            }
            
            let minGap = (r.lane == lane) ? GameConstants.Gameplay.sameLaneMinGap : GameConstants.Gameplay.diffLaneMinGap
            let rTop = r.topY
            let rBottom = rTop + h - 1
            
            // Нас интересуют только те, кто впереди по вертикали (ниже) или пересекается с зоной спавна.
            // Проверяем расстояние между новой (сверху) и существующей (снизу):
            let gap = rTop - newBottomY - 1
            if gap < minGap {
                return false
            }
            
            // На всякий случай: если вдруг уже есть машина, которая "залезла" в зону спавна сверху (редко),
            // можно дополнительно отсечь пересечения:
            if !(rBottom < newTopY || rTop > newBottomY) {
                return false
            }
        }
        
        return true
    }
    
    mutating func moveRivalCars(world: inout RaceWorld) {
        
        for i in world.rivalCars.indices {
            world.rivalCars[i].topY += 1
        }
        world.rivalCars.removeAll {
            $0.topY >= GameConstants.Field.rows
        }
    }

    func increaseLevel() {}
    
    
    func buildField(world: RaceWorld) -> [[Bool]] {
        var field = Array(
            repeating: Array(repeating: false, count: GameConstants.Field.columns),
            count: GameConstants.Field.rows
        )
        
        func drawCar(_ car: Car) {
            let laneIndex = car.lane - 1
            guard laneIndex >= 0 && laneIndex < GameConstants.Car.laneX.count else { return }
            let startX = GameConstants.Car.laneX[laneIndex]
            
            for dy in 0..<GameConstants.Car.height {
                let y = car.topY + dy
                if y < 0 || y >= GameConstants.Field.rows { continue }
                
                for dx in 0..<GameConstants.Car.width {
                    let x = startX + dx
                    if x < 0 || x >= GameConstants.Field.columns { continue }
                    field[y][x] = true
                }
            }
        }
        
        drawCar(world.playerCar)
        for r in world.rivalCars { drawCar(r) }
        
        return field
    }
    
    func emptyNext() -> [[Bool]] {
        // Заглушка, как требует спецификация
        Array(
            repeating: Array(repeating: false, count: GameConstants.Field.columns),
            count: GameConstants.Field.rows
        )
    }
    
    mutating func tick(world: inout RaceWorld, info: inout GameInfo, fsm: inout RaceFSM) {
        switch fsm.state {
            
        case .begin:
            info.pause = false
            info.field = buildField(world: world)
            info.next = emptyNext()
            
        case .generation:
            // Reset world
            world.playerCar = Car(lane: GameConstants.Car.startLane, topY: GameConstants.Car.startTopY)
            world.rivalCars.removeAll()
            
            world.tickCount = 0
            world.isAccelerating = false
            world.nextSpawnTick = Int.random(in: GameConstants.Gameplay.spawnEveryMinTicks...GameConstants.Gameplay.spawnEveryMaxTicks)
            
            // Reset info
            info.score = 0
            info.level = 1
            info.speed = GameConstants.Gameplay.normalStep
            info.pause = false
            
            // Start running
            fsm.state = .running
            
            info.field = buildField(world: world)
            info.next = emptyNext()
            
        case .movingLeft, .movingRight:
            moveCar(state: fsm.state, world: &world)
            fsm.state = .running
            
            info.field = buildField(world: world)
            info.next = emptyNext()
            
        case .running:
            info.pause = false
            
            // 1) tick count
            world.tickCount += 1
            
            // 2) maybe spawn
            if world.tickCount >= world.nextSpawnTick {
                spawnRival(world: &world)
                world.nextSpawnTick = world.tickCount + Int.random(
                    in: GameConstants.Gameplay.spawnEveryMinTicks...GameConstants.Gameplay.spawnEveryMaxTicks
                )
            }
            
            // 3) move rivals with acceleration; check collision between steps
            let steps = world.isAccelerating ? GameConstants.Gameplay.boostedStep : GameConstants.Gameplay.normalStep
            info.speed = steps
            
            for _ in 0..<steps {
                moveRivalCars(world: &world)
                if isCollision(world: world) {
                    fsm.handleCollision()
                    if info.score > info.highScore { info.highScore = info.score }
                    break
                }
            }
            
            // 4) scoring/leveling only if still running
            if fsm.state == .running {
                info.score += GameConstants.Gameplay.overtakePoints
                info.level = min(
                    GameConstants.Gameplay.maxLevel,
                    info.score / GameConstants.Gameplay.scoreToLevelUp + 1
                )
            }
            
            info.field = buildField(world: world)
            info.next = emptyNext()
            
        case .break:
            info.pause = true
            info.field = buildField(world: world)
            info.next = emptyNext()
            
        case .end:
            info.pause = false
            if info.score > info.highScore { info.highScore = info.score }
            info.field = buildField(world: world)
            info.next = emptyNext()
            
        case .exit:
            info.pause = false
            info.field = buildField(world: world)
            info.next = emptyNext()
        }
    }
    
}
