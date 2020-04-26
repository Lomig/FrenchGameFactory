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

    var printFactory: PrintFactory = PrintFactory()

    init() {
        self.printFactory = PrintFactory(game: self)
    }

    var status: [[String]] {
        var array = Array(repeating: Array(repeating: "", count: 4), count: 2)

        for (index, player) in players.enumerated() {
            array[index] = player.status
        }

        return array
    }

    // Main Gameplay Loop
    func start() {
        repeat {
            let attackerID = playerTurn.rawValue
            let defenderID = (playerTurn.rawValue + 1) % 2
            players[attackerID].play(against: players[defenderID], displayOn: printFactory, withStatus: status)

            playerTurn.toggle()
        } while !gameOver
    }

    // Add a player with 3 characters
    func addPlayer(_ playerName: String) {
        let newPlayer = Player(name: playerName)
        players.append(newPlayer)

        for i in 1 ... 3 {
            var heroName: String
            repeat {
                heroName = selectCharacterName(forHero: i, withTitle: "\(playerName)'s team")
            } while heroName == "" || isCharacterNameTaken(heroName)

            newPlayer.addCharacter(Character(name: heroName))
        }
    }

    // Get a Character Name from the player
    // Check if this name is already in use
    private func selectCharacterName(forHero i: Int, withTitle title: String) -> String {
        var heroName = ""
        printFactory.askUser(title: title, question: "Enter the name for your hero #\(i)", statusLeft: status.first!, statusRight: status.last!)

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
