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

    // printFactoryIndex is used by PrintFactory to know if it should print the Player and its Characters
    // on the left or the right side of the screen.
    let printFactoryIndex: [Int]
    var weapon: Weapon
    private let maxHitPoints: Int = 25
    private var currentHitPoints: Int
    private let printFactory: PrintFactory = PrintFactory.shared

    init(name: String, printFactoryIndex: [Int]) {
        self.name = name
        self.printFactoryIndex = printFactoryIndex
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
        printFactory.informUser(description: "\(name) has been hit for \("damage".pluralize(number: weapon.damage)).")
        if weapon.damage >= currentHitPoints {
            currentHitPoints = 0
            printFactory.informUser(description: "\(name) is lying on the ground!")
        } else {
            currentHitPoints -= weapon.damage
        }

        updateStatus()
    }

    func getChest() {
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

        // We send to the PrintFactory the public content of the Weapon instead of the Weapon itself
        // We try to avoid PrintFactory to know too much of the internal mechanics of what it has to print.
        // We display the chest here
        printFactory.openChest(for: name, content: [newWeaponDescription, String(newWeapon.damage), comparison])
        printFactory.displayChest()

        // We ask the user if he wants to keep his old weapon or change it
        tradeWeapon(with: newWeapon)
    }

    // Change the character weapon if the users wants to
    func tradeWeapon(with weapon: Weapon) {
        if let confirmation = readLine() {
            if ["yes", "y"].contains(confirmation.lowercased()) {
                self.weapon = weapon
                printFactory.closeChest()
                printFactory.informUser(description: ["\(name) found a treasure...", "\(name) has changed his weapon!"])
                updateStatus()
                return
            } else if ["no", "n"].contains(confirmation.lowercased()){
                printFactory.closeChest()
                printFactory.informUser(description: "\(name) found a treasure but left the treasure behind...")
                return
            }

        }
        printFactory.displayChest(retry: true)
        tradeWeapon(with: weapon)
    }

    // Print the character characteristics
    // We call this each time the character is being selected or suffers changes
    func updateStatus(isHighlighted: Bool = false) {
        printFactory.showCharacter(
            fromPlayer: printFactoryIndex.first!,
            ofIndex: printFactoryIndex.last!,
            name: name,
            damage: weapon.damage,
            currentHitPoints: currentHitPoints,
            maxHitPoints: maxHitPoints,
            isAlive: isAlive,
            isHighlighted: isHighlighted
        )
    }
}
