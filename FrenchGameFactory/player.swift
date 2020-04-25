//
//  player.swift
//  FrenchGameFactory
//
//  Created by Lomig Enfroy on 25/04/2020.
//  Copyright © 2020 Lomig Enfroy. All rights reserved.
//

import Foundation

class Player {
    var characters: [Character]

    init() {
        self.characters = []
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
