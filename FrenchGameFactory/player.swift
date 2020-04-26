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

        if !characters.isEmpty { array[0] = name }

        for (index, character) in characters.enumerated() {
            array[index + 1] = "\(index + 1) \(character.status)"
        }

        return array
    }

    func play(against opponent: Player, displayOn printFactory: PrintFactory, withStatus status: [[String]]) {

        let attacker = chooseCharacter(attackBy: self, role: "attacker", displayOn: printFactory, withStatus: status)
        let target = opponent.chooseCharacter(attackBy: self, role: "target", displayOn: printFactory, withStatus: status)
        attacker.attack(target)
    }

    func chooseCharacter(attackBy player: Player,
                         role: String,
                         displayOn printFactory: PrintFactory,
                         withStatus status: [[String]]) -> Character {
        printFactory.askUser(title: "\(player.name) is attacking!", question: "Choose your \(role)", statusLeft: status.first!, statusRight: status.last!)

        if let chosenValue = Int(readLine(strippingNewline: true)!) {
            if chosenValue > 0 && chosenValue <= characters.count {
                return characters[chosenValue - 1]
            }
        }
        return chooseCharacter(attackBy: player, role: role, displayOn: printFactory, withStatus: status)
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
