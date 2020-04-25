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
    
    func attack(_ opponent: Character) {
        opponent.takeDamage(from: self.weapon)
    }
    
    func takeDamage(from weapon: Weapon) {
        if weapon.damage >= self.currentHitPoints {
            return self.currentHitPoints = 0
        }
        
        self.currentHitPoints -= weapon.damage
    }
}
