//
//  character.swift
//  FrenchGameFactory
//
//  Created by Lomig Enfroy on 25/04/2020.
//  Copyright © 2020 Lomig Enfroy. All rights reserved.
//

import Foundation

class Character {
    let name: String
    let maxHitPoints: Int = 50
    var currentHitPoints: Int
    private var weapon: Weapon
    
    init(name: String) {
        self.name = name
        self.currentHitPoints = self.maxHitPoints
        self.weapon = Weapon()
    }
    
    var isAlive: Bool {
        return currentHitPoints > 0
    }
    
    var status: Any {
        return [self.isAlive, "Hit Points: \(self.currentHitPoints) / \(self.maxHitPoints)"]
    }
    
    func attack(_ opponent: Character) {
        opponent.takeDamage(from: self.weapon)
    }
    
    func takeDamage(from weapon: Weapon) {
        // Guard Clause: Negative hit points are impossible
        // If the damage is greater than the remaining hit points, hit points are set to 0
        if weapon.damage >= self.currentHitPoints {
            return self.currentHitPoints = 0
        }
        
        self.currentHitPoints -= weapon.damage
    }
}
