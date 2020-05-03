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
    let index: [Int]
    var weapon: Weapon
    private let maxHitPoints: Int = 50
    private var currentHitPoints: Int

    init(name: String, index: [Int]) {
        self.name = name
        self.index = index
        self.currentHitPoints = self.maxHitPoints
        self.weapon = Weapon()

        // Print the newly created character
        updateStatus()
    }

    var isAlive: Bool {
        return currentHitPoints > 0
    }

    func attack(_ opponent: Character) {
        opponent.takeDamage(from: self.weapon)
        updateStatus(isHighlighted: false)
    }

    func takeDamage(from weapon: Weapon) {
        // Negative hit points are impossible
        // If the damage is greater than the remaining hit points, hit points are set to 0
        PrintFactory.shared.informUser(description: "\(name) has been hit for \(weapon.damage) damages.")
        if weapon.damage >= currentHitPoints {
            currentHitPoints = 0
            PrintFactory.shared.informUser(description: "\(name) is lying on the ground!")
        } else {
            currentHitPoints -= weapon.damage
        }

        updateStatus()
    }

    // Print the character characteristics
    // We call this each time the character is being selected or suffers changes
    func updateStatus(isHighlighted: Bool = false) {
        PrintFactory.shared.showCharacter(
            fromPlayer: index.first!,
            ofIndex: index.last!,
            name: name,
            damage: weapon.damage,
            currentHitPoints: currentHitPoints,
            maxHitPoints: maxHitPoints,
            isAlive: isAlive,
            isHighlighted: isHighlighted
        )
    }
}
