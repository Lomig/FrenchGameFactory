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
    private var printFactory: PrintFactory = ConsolePrintFactory.shared

    var gameOver: Bool {
        return players.first { player in player.isWiped } != nil
    }


    // Main Gameplay Loop
    func start() {
        repeat {
            printFactory.currentPlayer = playerTurn
            players[playerTurn.currentPlayer()].play(against: players[playerTurn.nextPlayer()])

            playerTurn.toggle()
        } while !gameOver

        declareWinningTeam()
    }

    // Add a player with 3 characters
    func addPlayer(_ playerName: String) {
        let newPlayer = Player(name: playerName, printFactoryIndex: players.count)

        // Storing the player turn in the Print Factory
        // Used there to chose the color to display for each team
        // Blue for Player1, Purple for Player2
        printFactory.currentPlayer = playerTurn
        printFactory.changeTitle(with: "\(playerName)'s team")

        players.append(newPlayer)

        (1...Player.maxNumberOfCharacters).forEach { i in
            var heroName: String
            repeat {
                heroName = selectCharacterName(forHero: i, forPlayer: PlayerTurn(rawValue: newPlayer.printFactoryIndex)!)
            } while heroName == ""

            let heroClass: HeroClass = selectCharacterClass(for: heroName, forPlayer: PlayerTurn(rawValue: newPlayer.printFactoryIndex)!)

            // Show "Player 1" / "Player 2" as soon as it has at least one character
            printFactory.showPlayerName(forPlayer: newPlayer.printFactoryIndex, name: newPlayer.name)
            newPlayer.addCharacter(named: heroName, class: heroClass)
        }
        playerTurn.toggle()
    }

    // Get a Character Name from the player
    // Check if this name is already in use
    private func selectCharacterName(forHero i: Int, forPlayer player: PlayerTurn) -> String {
        var heroName: String = ""
        printFactory.askUser(question: "Enter the name for your hero #\(i): (15 characters max)", colorize: true)

        if let input = readLine() {
            heroName = String(input.prefix(15)).capitalized
        }

        if isCharacterNameTaken(heroName) {
            printFactory.informUser(description: "\(heroName) is already taken :(")
            return selectCharacterName(forHero: i, forPlayer: player )
        }

        return heroName
    }

    // Get a Character Class from the player
    private func selectCharacterClass(for name: String, forPlayer player: PlayerTurn) -> HeroClass {
        let classExplanation: [String] = [
            "1 - Tank: has more HP, but does less damage.",
            "2 - Barbarian: has less HP, but does more damage."
        ]
        printFactory.informUser(description: classExplanation)
        printFactory.askUser(question: "Select a class for \(name) (1-2):", colorize: true)

        guard let input = Int(readLine()!), input > 0, input <= 2 else {
            printFactory.informUser(description: "This is not a valid input. Retrying...", color: .yellow)
            return selectCharacterClass(for: name, forPlayer: player)
        }

        // Delete class descriptions
        printFactory.informUser(description: ["", "", ""])
        return HeroClass(rawValue: input)!
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

        printFactory.hideQuestionSection()

        if player1Wiped && player2Wiped {
            return printFactory.informUser(description: ["", "Tie! Noone won this round!", ""])
        }

        let name: String = player1Wiped ? players.last!.name : players.first!.name
        printFactory.informUser(description: ["", "Victory for \(name)!", ""])
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
