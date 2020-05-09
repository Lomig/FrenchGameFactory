//
//  characterClasses.swift
//  FrenchGameFactory
//
//  Created by Lomig Enfroy on 09/05/2020.
//  Copyright © 2020 Lomig Enfroy. All rights reserved.
//

import Foundation

// Tank
// A Tank has more health but does less damage
class Tank: Character {
    private let maxHitPoints: Int = 40
    private let force: Int = 5
}



// Barbarian
// A Barbarian has less health but does more damage
class Barbarian: Character {
    private let maxHitPoints: Int = 20
    private let force: Int = 15

}

enum HeroClass {
    case tank, barbarian
}
