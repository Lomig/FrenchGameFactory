//
//  weapon.swift
//  FrenchGameFactory
//
//  Created by Lomig Enfroy on 25/04/2020.
//  Copyright © 2020 Lomig Enfroy. All rights reserved.
//

import Foundation

class Weapon {
    private static let weaponNames: [String] = [
        "sword",
        "axe",
        "shovel",
        "bow",
        "mace",
        "spear",
        "fork",
        "shoe",
        "smelly cheese",
        "ruler",
    ]
    private static let weaponPrefix: [String] = [
        "Rusty",
        "Golden",
        "Devilish",
        "Almighty",
        "Not-so-impressive",
        "Hungry",
        "Sexy",
        "Warm",
        "Soft",
        "Pink",
        "Average",
        "Borrowed",
        "Quarantined",
    ]
    private static let weaponSuffix: [String] = [
        " of the mighty",
        " of the beast",
        " of the devot",
        " with deadly spikes",
        " that may be magical",
        " you cannot parry",
        " from last Christmas",
        " everyone desire",
        ", vanquisher of the Battle of Markravelt",
        " stolen from a lonely school teacher",
    ]

    let name: String
    let damage: Int

    // User story: Chests with upgraded weapons
    // We must be able to create weapons that are better than a previous one
    // We can then initialize a weapon with a minimum damage number
    init(minDamage: Int = 0) {
        // User story: Randomness is a required characteristic
        // 55% chances of having a better weapon
        if Int.random(in: 1...100) > 55 {
            // The damage from a weapon is random (up to 5 damage above or below the previous one)
            // The damage cannot be below 1
            self.damage = max(1, Int.random(in: minDamage - 5 ... minDamage))
        } else {
            // The damage from a weapon is random (1 — 5 damage above the previous one)
            self.damage = Int.random(in: minDamage + 1 ... minDamage + 5)
        }

        // Let's have some funny weapon names!
        self.name = "\(Weapon.weaponPrefix.randomElement()!) \(Weapon.weaponNames.randomElement()!)\(Weapon.weaponSuffix.randomElement()!)"
    }
}
