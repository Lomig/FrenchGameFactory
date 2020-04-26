//
//  main.swift
//  FrenchGameFactory
//
//  Created by Lomig Enfroy on 25/04/2020.
//  Copyright © 2020 Lomig Enfroy. All rights reserved.
//

import Foundation

let game = Game()

game.addPlayer("Player 1")
game.addPlayer("Player 2")
game.start()


// Return gracefullt the cursor bottom left of the screen
print("\u{1B}[6E")

