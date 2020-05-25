//
//  game.swift
//  FrenchGameFactory
//
//  Created by Lomig Enfroy on 25/04/2020.
//  Copyright © 2020 Lomig Enfroy. All rights reserved.
//

import Foundation

class Game {
    private var players: [Player] = []
    private var playerTurn: PlayerTurn = .player1
    private var printFactory: PrintFactory = ConsolePrintFactory.shared
    private var numberOfTurn: Int = 0

    private var gameOver: Bool { players.first { player in player.isWiped } != nil }


    // Main Gameplay Loop
    func start() {
        repeat {
            numberOfTurn += 1

            // Storing the player turn in the Print Factory
            // Used there to chose the color to display for each team
            // Blue for Player1, Purple for Player2
            printFactory.currentPlayer = playerTurn
            players[playerTurn.currentPlayer()].play(against: players[playerTurn.nextPlayer()])

            playerTurn.toggle()
        } while !gameOver

        declareWinningTeam()
    }

    // Add a player with 3 characters
    func addPlayer(_ playerName: String) {
        let newPlayer: Player = Player(name: playerName, printFactoryIndex: players.count)

        // Storing the player turn in the Print Factory
        // Used there to chose the color to display for each team
        // Blue for Player1, Purple for Player2
        printFactory.currentPlayer = playerTurn
        printFactory.changeTitle(with: "\(playerName)'s team")

        players.append(newPlayer)

        (1...Player.maxNumberOfCharacters).forEach { i in
            let heroName: String = selectCharacterName(forHero: i, forPlayer: PlayerTurn(rawValue: newPlayer.printFactoryIndex)!)
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
        printFactory.askUser(question: "Enter the name for your hero #\(i): (15 characters max)", colorize: true)
        guard let input = readLine(), input != "" else { return selectCharacterName(forHero: i, forPlayer: player) }

        let heroName = String(input.prefix(15)).capitalized
        if isCharacterNameTaken(heroName) {
            printFactory.informUser(description: "\(heroName) is already taken :(")
            return selectCharacterName(forHero: i, forPlayer: player)
        }

        return heroName
    }

    // Get a Character Class from the player
    private func selectCharacterClass(for name: String, forPlayer player: PlayerTurn) -> HeroClass {
        var classExplanation: [String] = []

        // Metaprogramming Exercise!
        // For each enum type, we get the name of the enum
        // From this name, we get the Swift class from that name to use methods from this Swift Class
        // className to get the internal name of the Character Class
        // classDescription to get the internal description of the Character Class
        HeroClass.allCases.forEach { heroClass in
            let heroClassClass = NSClassFromString("FrenchGameFactory.\(String(describing: heroClass))") as! Character.Type
            classExplanation.append("\(heroClass.rawValue) - \(heroClassClass.className): \(heroClassClass.classDescription)")
        }

        printFactory.informUser(description: classExplanation)
        printFactory.askUser(question: "Select a class for \(name) (1-\(HeroClass.allCases.count)):", colorize: true)

        // Retry selection if the User input is not correct
        guard let input = Int(readLine()!), input > 0, input <= HeroClass.allCases.count else {
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
        printFactory.informUser(description: ["", "Victory for \(name)!", "They took \(numberOfTurn) to accomplish this deed."])
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
