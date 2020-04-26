//
//  player.swift
//  FrenchGameFactory
//
//  Created by Lomig Enfroy on 25/04/2020.
//  Copyright © 2020 Lomig Enfroy. All rights reserved.
//

import Foundation

class Player {
    var name: String
    var characters: [Character] = []

    init(name: String) {
        self.name = name
    }

    var status: [String] {
        var array = Array(repeating: "", count: 4)

        array[0] = name

        for (index, character) in characters.enumerated() {
            array[index + 1] = "\(index + 1) \(character.status)"
        }

        return array
    }

    func play(against opponent: Player) {

        let attacker = chooseCharacter(who: "attack")
        let target = opponent.chooseCharacter(who: "will be attacked")
        attacker.attack(target)
    }

    func chooseCharacter(who action: String) -> Character {
        print("Please chose the character who will \(action):")
        print(" > ", terminator: " ")
        if let chosenValue = Int(readLine(strippingNewline: true)!) {
            if chosenValue >= 0 && chosenValue < characters.count {
                return characters[chosenValue]
            }
        }

        print("Wrong selection!")
        return chooseCharacter(who:action)
    }

    func addCharacter(_ character: Character) {
        characters.append(character)
    }

    func isCharacterNameTaken(_ name: String) -> Bool {
        for character in self.characters {
            if character.name == name { return true }
        }

        return false
    }
}
