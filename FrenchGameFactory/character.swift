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
    private let maxHitPoints: Int = 10
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
        opponent.takeDamage(from: weapon)
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

    func getCrate() {
        let newWeapon = Weapon(min_damage: weapon.damage)
        let newWeaponDescription: String = "It's a \(newWeapon.name.capitalized)!"
        let comparison: String

        if weapon.damage < newWeapon.damage {
            comparison = "It's better than your \(weapon.name.capitalized)!"
        } else if weapon.damage > newWeapon.damage {
            comparison = "It's no better than your \(weapon.name.capitalized)..."
        } else {
            comparison = "Frankly? I cannot see the difference with your \(weapon.name.capitalized)..."
        }

        PrintFactory.shared.openChest(for: name, content: [newWeaponDescription, String(newWeapon.damage), comparison])
        PrintFactory.shared.displayChest()
        tradeWeapon(with: newWeapon)
    }

    func tradeWeapon(with weapon: Weapon) {
        if let confirmation = readLine(strippingNewline: true) {
            if ["yes", "y"].contains(confirmation.lowercased()) {
                self.weapon = weapon
                PrintFactory.shared.closeChest()
                PrintFactory.shared.informUser(description: ["\(name) found a treasure...", "\(name) has changed his weapon!"])
                updateStatus()
                return
            } else if ["no", "n"].contains(confirmation.lowercased()){
                PrintFactory.shared.closeChest()
                PrintFactory.shared.informUser(description: ["\(name) found a treasure...", "\(name) left the treasure behind."])
                return
            }

        }
        PrintFactory.shared.displayChest(retry: true)
        tradeWeapon(with: weapon)
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
