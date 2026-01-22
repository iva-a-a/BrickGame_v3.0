//
//  RaceWorld.swift
//  Race
//
//  Created by Alena Ivanova on 12.01.2026.
//

//struct RaceWorld {
//    var playerCar: Car
//    var rivalCars: [Car]
//}

struct RaceWorld {
  var playerCar: Car
  var rivalCars: [Car] = []

  // Для тайминга/спавна/ускорения
  var tickCount: Int = 0
  var nextSpawnTick: Int = 0
  var isAccelerating: Bool = false
}
