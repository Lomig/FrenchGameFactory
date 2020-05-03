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

    var status: [String] {
        var array = Array(repeating: "", count: 4)

        if !characters.isEmpty { array[0] = name }

        for (index, character) in characters.enumerated() {
            array[index + 1] = "\(index + 1) \(character.status)"
        }

        return array
    }

    func play(against opponent: Player) {

        let attacker = chooseCharacter(attackBy: self, role: "attacker")
        attacker.updateStatus(isHighlighted: true)
        
        let target = opponent.chooseCharacter(attackBy: self, with: attacker, role: "target")
        attacker.attack(target)
    }

    func chooseCharacter(attackBy player: Player, with boxedCharacter: Character? = nil, role: String) -> Character {

        var description: [String] = []
        if let character = boxedCharacter {
            description = ["\(character.name) attacks!"]
        } else {
            description = ["\(player.name) is choosing their attacker..."]
        }

        PrintFactory.shared.changeTitle(with: "\(player.name) is attacking!")
        PrintFactory.shared.informUser(description: description)
        PrintFactory.shared.askUser(question: "Choose your \(role)", colorize: true)

        if let chosenValue = Int(readLine(strippingNewline: true)!) {
            if chosenValue > 0 && chosenValue <= characters.count {
                return characters[chosenValue - 1]
            }
        }
        return chooseCharacter(attackBy: player, role: role)
    }

    func addCharacter(named name: String) {
        let new_character = Character(name: name, index: [self.index, characters.count])
        characters.append(new_character)
    }

    func isCharacterNameTaken(_ name: String) -> Bool {
        for character in self.characters {
            if character.name == name { return true }
        }

        return false
    }
}
