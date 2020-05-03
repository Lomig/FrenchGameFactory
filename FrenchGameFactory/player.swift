//
//  player.swift
//  FrenchGameFactory
//
//  Created by Lomig Enfroy on 25/04/2020.
//  Copyright © 2020 Lomig Enfroy. All rights reserved.
//

import Foundation

class Player {
    let name: String
    let index: Int
    var characters: [Character] = []

    init(name: String, index: Int) {
        self.name = name
        self.index = index

    }

    // Main Action between two characters
    func play(against opponent: Player) {
        // Choose an attacker to play with
        let attacker = chooseCharacter(attackBy: self, role: "attacker")
        attacker.updateStatus(isHighlighted: true)

        // Choose a target to play against
        let target = opponent.chooseCharacter(attackBy: self, with: attacker, role: "target")
        attacker.attack(target)
    }

    // Choose character from the User input.
    // If the input is not a number within the index, or if the character selected is already dead
    // Recursively retry
    func chooseCharacter(attackBy player: Player, with boxedCharacter: Character? = nil, role: String) -> Character {
        if let character = boxedCharacter {
            PrintFactory.shared.informUser(description: "\(character.name) attacks!")
        }

        PrintFactory.shared.changeTitle(with: "\(player.name) is attacking!")
        PrintFactory.shared.askUser(question: "\(player.name), choose your \(role):", colorize: true)


        if let chosenValue = Int(readLine(strippingNewline: true)!) {
            if chosenValue > 0 && chosenValue <= characters.count {
                // Clause Guard: Success!
                if characters[chosenValue - 1].isAlive { return characters[chosenValue - 1] }

                PrintFactory.shared.informUser(description: "This character is out of combat :( Try again!")
            }
        } else {
            PrintFactory.shared.informUser(description: "This is not a valid input. Retrying...")
        }

        // Pure recursive call as the last line
        // I don't know if Swift does TCO, but it does not hurt to do as if it was the case.
        return chooseCharacter(attackBy: player, role: role)
    }

    // Add a new character for the player
    func addCharacter(named name: String) {
        let new_character = Character(name: name, index: [index, characters.count])
        characters.append(new_character)
    }

    // Check if a name is already in use in this team
    func isCharacterNameTaken(_ name: String) -> Bool {
        // Pascal: Here is an exemple where forEach cannot be used because of early returns
        // We can avoid this by creating a local variable and iterate through the entire array
        // But it's less elegant :)
        for character in characters {
            if character.name == name { return true }
        }

        return false
    }
}
