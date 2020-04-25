//
//  weapon.swift
//  FrenchGameFactory
//
//  Created by Lomig Enfroy on 25/04/2020.
//  Copyright © 2020 Lomig Enfroy. All rights reserved.
//

import Foundation

class Weapon {
    static let weaponNames = [
        "Sword",
        "Axe",
        "Shovel",
        "Bow",
        "Mace",
        "Spear"
    ]
    static let weaponQualifiers = [
        "of the mighty",
        "of the beast",
        "of the devot",
        "with deadly spikes",
        "that may be magical",
        "you cannot parry"
    ]
    
    let name: String
    let damage: Int
    
    init(min_damage: Int = 0) {
        self.damage = Int.random(in: min_damage + 1 ... 5)
        self.name = "\(Weapon.weaponNames.randomElement()!) \(Weapon.weaponQualifiers.randomElement()!)"
    }
}
