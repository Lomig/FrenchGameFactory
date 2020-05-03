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
            PrintFactory.shared.currentPlayer = playerTurn
            let attackerID = playerTurn.rawValue
            let defenderID = (playerTurn.rawValue + 1) % 2
            players[attackerID].play(against: players[defenderID])

            playerTurn.toggle()
        } while !gameOver
    }

    // Add a player with 3 characters
    func addPlayer(_ playerName: String) {
        let newPlayer = Player(name: playerName, index: players.count)
        PrintFactory.shared.currentPlayer = playerTurn
        PrintFactory.shared.changeTitle(with: "\(playerName)'s team")
        players.append(newPlayer)

        for i in 1 ... 3 {
            var heroName: String
            repeat {
                heroName = selectCharacterName(forHero: i, forPlayer: PlayerTurn(rawValue: newPlayer.index)!)
            } while heroName == "" || isCharacterNameTaken(heroName)

            PrintFactory.shared.showPlayerName(forPlayer: newPlayer.index, name: newPlayer.name)
            newPlayer.addCharacter(named: heroName)
        }
        playerTurn.toggle()
    }

    // Get a Character Name from the player
    // Check if this name is already in use
    private func selectCharacterName(forHero i: Int, forPlayer player: PlayerTurn) -> String {
        var heroName = ""
        PrintFactory.shared.askUser(question: "Enter the name for your hero #\(i)", colorize: true)

        if let input = readLine(strippingNewline: true) {
            heroName = input.capitalized
        }

        if isCharacterNameTaken(heroName) {
            PrintFactory.shared.informUser(description: "\(heroName) is already taken :(")
            return selectCharacterName(forHero: i, forPlayer: player )
        }

        return heroName
    }

    // Check if a Character name is already in Use
    // Pascal: Here is an exemple where forEach cannot be used because of early returns
    // We can avoid this by creating a local variable and iterate through the entire array
    // But it's less elegant :)
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
