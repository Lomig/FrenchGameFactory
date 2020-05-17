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
    override var maxHitPoints: Int { 40 }
    override var force: Int { 5 }
}



// Barbarian
// A Barbarian has less health but does more damage
class Barbarian: Character {
    override var maxHitPoints: Int { 20 }
    override var force: Int { 15 }

}

enum HeroClass: Int {
    case tank = 1
    case barbarian = 2
}
