//
//  game.swift
//  FrenchGameFactory
//
//  Created by Lomig Enfroy on 25/04/2020.
//  Copyright © 2020 Lomig Enfroy. All rights reserved.
//

import Foundation

class Game {
    var players: [Player] = []
    var playerTurn: PlayerTurn = .player1
    var gameOver = false

    // Main Gameplay Loop
    func start() {
        repeat {
            let attackerID = playerTurn.rawValue
            let defenderID = (playerTurn.rawValue + 1) % 2
            players[attackerID].play(against: players[defenderID])

            playerTurn.toggle()
        } while !gameOver
    }

    // Add a player with 3 characters
    func addPlayer(_ playerName: String) {
        let newPlayer = Player()
        players.append(newPlayer)
        print("\n\(playerName), enter the name of your three heroes!")

        for i in 1 ... 3 {
            var heroName: String
            repeat {
                heroName = selectCharacterName(forHero: i)
            } while heroName == "" || isCharacterNameTaken(heroName)

            newPlayer.addCharacter(Character(name: heroName))
        }
    }

    // Get a Character Name from the player
    // Check if this name is already in use
    private func selectCharacterName(forHero i: Int) -> String {
        var heroName = ""
        print("Please enter the name for your hero #\(i):")
        print(" >", terminator: " ")

        if let input = readLine(strippingNewline: true) {
            heroName = input
        }

        if isCharacterNameTaken(heroName) {
            print("This hero name is already taken :(")
        }

        return heroName
    }

    // Check if a Character name is already in Use
    private func isCharacterNameTaken(_ name: String) -> Bool {
        for player in players {
            if player.isCharacterNameTaken(name) {
                return true
            }
        }

        return false
    }
}

enum PlayerTurn: Int {
    case player1, player2

    mutating func toggle() {
        switch(self) {
        case .player1: self = .player2
        case .player2: self = .player1
        }
    }
}
