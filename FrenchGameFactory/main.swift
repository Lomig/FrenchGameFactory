//
//  main.swift
//  FrenchGameFactory
//
//  Created by Lomig Enfroy on 25/04/2020.
//  Copyright © 2020 Lomig Enfroy. All rights reserved.
//

import Foundation

let player1 = Player()
player1.addCharacter(Character(name: "Truc"))
player1.addCharacter(Character(name: "Bidule"))
print(player1.isCharacterNameTaken("Truc"))
print(player1.isCharacterNameTaken("Bidule"))
print(player1.isCharacterNameTaken("Machin"))

