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

    var gameOver: Bool {
        return players.first { player in player.isWiped } != nil
    }


    // Main Gameplay Loop
    func start() {
        repeat {
            PrintFactory.shared.currentPlayer = playerTurn
            players[playerTurn.currentPlayer()].play(against: players[playerTurn.nextPlayer()])

            playerTurn.toggle()
        } while !gameOver

        declareWinningTeam()
    }

    // Add a player with 3 characters
    func addPlayer(_ playerName: String) {
        let newPlayer = Player(name: playerName, index: players.count)

        // Storing the player turn in the Print Factory
        // Used there to chose the color to display for each team
        // Blue for Player1, Purple for Player2
        PrintFactory.shared.currentPlayer = playerTurn
        PrintFactory.shared.changeTitle(with: "\(playerName)'s team")

        players.append(newPlayer)

        (1...Player.maxNumberOfCharacters).forEach { i in
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
        var heroName: String = ""
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
    private func isCharacterNameTaken(_ name: String) -> Bool {
        return players.first { player in player.isCharacterNameTaken(name) } != nil
    }

    // Check teams to know who is the winner
    // One, the other, or a tie
    private func declareWinningTeam() {
        let player1Wiped: Bool = players.first!.isWiped
        let player2Wiped: Bool = players.last!.isWiped

        PrintFactory.shared.askUser(false)

        if player1Wiped && player2Wiped {
            return PrintFactory.shared.informUser(description: ["", "Tie! Noone won this round!", ""])
        }

        let name: String = player1Wiped ? players.last!.name : players.first!.name
        PrintFactory.shared.informUser(description: ["", "Victory for \(name)!", ""])
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

    func currentPlayer() -> Int {
        return self.rawValue
    }

    func nextPlayer() -> Int {
        switch self {
        case .player1: return 1
        case .player2: return 0
        }
    }
}
