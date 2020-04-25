//
//  main.swift
//  FrenchGameFactory
//
//  Created by Lomig Enfroy on 25/04/2020.
//  Copyright © 2020 Lomig Enfroy. All rights reserved.
//

import Foundation

let weapon = Weapon(min_damage: 80)

let character1 = Character(name: "Player1")
let character2 = Character(name: "Player2")

character1.attack(character2)
print(character2.status)
let array = [character1, character2]
array[1].attack(array[0])
print(character1.status)

character1.takeDamage(from: weapon)
print(character1.status)
