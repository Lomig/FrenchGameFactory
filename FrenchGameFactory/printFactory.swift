//
//  printFactory.swift
//  FrenchGameFactory
//
//  Created by Lomig Enfroy on 26/04/2020.
//  Copyright © 2020 Lomig Enfroy. All rights reserved.
//

import Foundation

class PrintFactory {

    var currentPlayer: PlayerTurn = .player1
    private var lines: [String] = []
    private var players: [String] = []
    private var characters: [[String]] = [[]]
    static let shared =  PrintFactory()


    private init(){
        resetDisplay()
    }    

    func askUser(question: String, colorize: Bool = false) {

        var color = Color.white
        if colorize {
            color = currentPlayer.rawValue == 0 ? .blue : .purple
        }


        updateQuestion(with: question, color: color)
        display()
    }

    func changeTitle(with title: String, colorize: Bool = false) {
        var color = Color.white
        if colorize {
            color = currentPlayer.rawValue == 0 ? .blue : .purple
        }

        updateTitle(with: title, color: color)

        display()
    }

    func showPlayerName(forPlayer playerIndex: Int, name: String) {
        let paddedName = name.padding(toLength: 17, withPad: " ", startingAt: 0)
        let playerStatus = "\(paddedName) DMG   HIT"
        let color = playerIndex == 0 ? Color.blue : Color.purple

        players[playerIndex] = colorString(padLine(playerStatus), color: color)
        updateStatus()

        display()
    }

    func showCharacter(fromPlayer playerIndex: Int, ofIndex characterIndex: Int, name: String, damage: Int, currentHitPoints: Int, maxHitPoints: Int, isAlive: Bool, isHighlighted: Bool) {
        let id = characterIndex + 1
        let paddedName = name.padding(toLength: 16, withPad: " ", startingAt: 0)
        let paddedDamage = String(format: "%02d", damage)
        let hitPoints = "\(String(format: "%02d", currentHitPoints))/\(maxHitPoints)"
        let characterInfo = "\(id) \(paddedName) \(paddedDamage) \(hitPoints)"
        let color: Color

        if !isAlive {
            color = .red
        } else if isHighlighted {
            color = .yellow
        } else if playerIndex == 0 {
            color = .blue
        } else {
            color = .purple
        }

        characters[playerIndex][characterIndex] = colorString(padLine(characterInfo), color: color)
        updateStatus()

        display()
    }

    func informUser(description: [String]) {
        updateDescription(with: description)

        display()
    }

    func display() {
        clearScreen()
        header()
        innerText()
        footer()
        cursorToPosition()
    }

    private func updateTitle(with title: String, color: Color) {
        lines[0] = "\u{001B}[1m" + colorString(centerLine(title).uppercased(), color: color)  + "\u{001B}[0m"
    }

    // Update the Status section
    // Composed of the player's name, weapon damage, and hit points
    private func updateStatus() {
        lines[3] = players.first! + "    " + players.last!

        for i in 0...2 {
            lines[i + 5] = characters.first![i] + "    " + characters.last![i]
        }
    }

    // Update the Description section
    // A new description "pushes" former ones up
    private func updateDescription(with description: [String]) {
        description.forEach { line in
            lines[9] = lines[10]
            lines[10] = lines[11]
            lines[11] = padLine(line, fullLine: true)
        }
    }

    private func updateQuestion(with question: String, color: Color) {
        lines[13] = colorString(padLine(question, fullLine: true), color: color)
        lines[14] = padLine(">", fullLine: true)
    }

    private func padLine(_ line: String, fullLine: Bool = false) -> String {
        let padding = fullLine ? 58 : 27

        return line.padding(toLength: padding, withPad: " ", startingAt: 0)
    }

    private func centerLine(_ line: String) -> String {
        // The available space is 58 characters
        // Centering text means splitting what's left in half
        let paddingSize = (58 - line.count) / 2
        let leftPadding = String(repeating: " ", count: paddingSize)
        return (leftPadding + line).padding(toLength: 58, withPad: " ", startingAt: 0)
    }

    private func colorString(_ string: String, color: Color) -> String {
        return color.rawValue + string + "\u{001B}[0m"
    }

    private func innerText() {
        print("""
         \\/ /\\ \\  \(lines[0])  / /\\/ /
         / /\\/ /  \(lines[1])  \\ \\/ /\\
        / /\\ \\/   \(lines[2])   \\ \\/\\ \\
        \\ \\/\\ \\   \(lines[3])   /\\ \\/ /
         \\/ /\\ \\  \(lines[4])  / /\\/ /
         / /\\/ /  \(lines[5])  \\ \\/ /\\
        / /\\ \\/   \(lines[6])   \\ \\/\\ \\
        \\ \\/\\ \\   \(lines[7])   /\\ \\/ /
         \\/ /\\ \\  \(lines[8])  / /\\/ /
         / /\\/ /  \(lines[9])  \\ \\/ /\\
        / /\\ \\/   \(lines[10])   \\ \\/\\ \\
        \\ \\/\\ \\   \(lines[11])   /\\ \\/ /
         \\/ /\\ \\  \(lines[12])  / /\\/ /
         / /\\/ /  \(lines[13])  \\ \\/ /\\
        / /\\ \\/   \(lines[14])   \\ \\/\\ \\
        """)
    }

    private func header() {
        print("""
         .--..--..--..--..--..--..--..--..--..--..--..--..--..--..--..--..--..--..--.
        / .. \\.. \\.. \\.. \\.. \\.. \\.. \\.. \\.. \\.. \\.. \\.. \\.. \\.. \\.. \\.. \\.. \\.. \\.. \\
        \\ \\/\\ \\/\\ \\/\\ \\/\\ \\/\\ \\/\\ \\/\\ \\/\\ \\/\\ \\/\\ \\/\\ \\/\\ \\/\\ \\/\\ \\/\\ \\/\\ \\/\\ \\/\\ \\/ /
         \\/ /\\/ /\\/ /\\/ /\\/ /\\/ /\\/ /\\/ /\\/ /\\/ /\\/ /\\/ /\\/ /\\/ /\\/ /\\/ /\\/ /\\/ /\\/ /
         / /\\/ /`' /`' /`' /`' /`' /`' /`' /`' /`' /`' /`' /`' /`' /`' /`' /`' /\\/ /\\
        / /\\ \\/`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'\\ \\/\\ \\
        \\ \\/\\ \\                                                                /\\ \\/ /
        """)
    }

    private func footer() {
        print("""
        \\ \\/\\ \\.--..--..--..--..--..--..--..--..--..--..--..--..--..--..--..--./\\ \\/ /
         \\/ /\\/ ../ ../ ../ ../ ../ ../ ../ ../ ../ ../ ../ ../ ../ ../ ../ ../ /\\/ /
         / /\\/ /\\/ /\\/ /\\/ /\\/ /\\/ /\\/ /\\/ /\\/ /\\/ /\\/ /\\/ /\\/ /\\/ /\\/ /\\/ /\\/ /\\/ /\\
        / /\\ \\/\\ \\/\\ \\/\\ \\/\\ \\/\\ \\/\\ \\/\\ \\/\\ \\/\\ \\/\\ \\/\\ \\/\\ \\/\\ \\/\\ \\/\\ \\/\\ \\/\\ \\/\\ \\
        \\ `'\\ `'\\ `'\\ `'\\ `'\\ `'\\ `'\\ `'\\ `'\\ `'\\ `'\\ `'\\ `'\\ `'\\ `'\\ `'\\ `'\\ `'\\ `' /
         `--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'`--'
        """)
    }

    private func treasureChest() {
        print("""
         \\/ /\\ \\  \(lines[0])  / /\\/ /
         / /\\/ /  \(lines[1])  \\ \\/ /\\
        / /\\ \\/      __________      \(lines[2])   \\ \\/\\ \\
        \\ \\/\\ \\     /\\____;;___\\     \(lines[3])   /\\ \\/ /
         \\/ /\\ \\   | /         /     \(lines[4])  / /\\/ /
         / /\\/ /   `. ())oo() .      \(lines[5])  \\ \\/ /\\
        / /\\ \\/     |\\(%()*^^()^\\    \(lines[6])   \\ \\/\\ \\
        \\ \\/\\ \\    %| |-%-------|    \(lines[7])   /\\ \\/ /
         \\/ /\\ \\  % \\ | %  ))   |    \(lines[8])  / /\\/ /
         / /\\/ /  %  \\|%________|    \(lines[9])  \\ \\/ /\\
        / /\\ \\/    %%%%              \(lines[10])   \\ \\/\\ \\
        \\ \\/\\ \\   \(lines[11])   /\\ \\/ /
         \\/ /\\ \\  \(lines[12])  / /\\/ /
         / /\\/ /  \(lines[13])  \\ \\/ /\\
        / /\\ \\/   \(lines[14])  \\ \\/\\ \\
        """)
    }

    private func resetDisplay(display: String = "Normal") {
        lines = Array(repeating: String(repeating: " ", count: 58), count: 15)
        players = Array(repeating: String(repeating: " ", count: 27), count: 2)
        characters = Array(repeating: Array(repeating: String(repeating: " ", count: 27), count: 3), count: 2)

        if display == "Chest" {
            for i in 2...10 {
                lines[i] = String(repeating: " ", count: 39)
            }
        }
    }

    private func clearScreen() {
        // Clear Screen
        print("\u{1B}[2J", terminator: "")
        // Position the cursor on the second line, first column
        print("\u{1B}[2;1H", terminator: "")
    }

    private func cursorToPosition() {
        // Position the cursor on the right line for user's input
        print("\u{1B}[23;13H", terminator: "")
    }
}

enum Color: String {
    case red = "\u{001B}[91m"
    case blue = "\u{001B}[34m"
    case purple = "\u{001B}[35m"
    case yellow = "\u{001B}[33m"
    case white = "\u{001B}[37m"
}
