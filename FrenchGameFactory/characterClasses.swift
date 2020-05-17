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
    override class var className: String { "Tank" }
    override class var classDescription: String { "has more HP, but does less damage." }
}



// Barbarian
// A Barbarian has less health but does more damage
class Barbarian: Character {
    override var maxHitPoints: Int { 20 }
    override var force: Int { 15 }
    override class var className: String { "Barbarian" }
    override class var classDescription: String { "has less HP, but does more damage." }

}



// JackOfAllTrades
// A Jack of All Trades has balanced HP and balanced damages.
class JackOfAllTrades: Character {
    override var maxHitPoints: Int { 30 }
    override var force: Int { 10 }
    override class var className: String { "Jack of All Trades" }
    override class var classDescription: String { "balanced HP for balanced damages." }

}

enum HeroClass: Int, CaseIterable {
    case Tank = 1
    case Barbarian
    case JackOfAllTrades
}
