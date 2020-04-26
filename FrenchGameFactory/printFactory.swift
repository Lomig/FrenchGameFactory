//
//  printFactory.swift
//  FrenchGameFactory
//
//  Created by Lomig Enfroy on 26/04/2020.
//  Copyright © 2020 Lomig Enfroy. All rights reserved.
//

import Foundation

class PrintFactory {
    private var lines: [String] = []
    private var title: String = "FrenchGameFactory RPG"
    private let game: Game?

    init(game: Game? = nil){
        self.game = game
    }
    

    func askUser(title: String, question: String, statusLeft: [String], statusRight: [String]) {
        clearScreen()
        resetDisplay()
        updateTitle(with: title)
        updateStatus(left: statusLeft, right:statusRight)
        updateQuestion(with: question)

        display()
    }

    private func display() {
        header()
        innerText()
        footer()
        cursorToPosition()
    }

    private func updateTitle(with title: String) {
        self.title = title
        lines[0] = "\u{001B}[1m" + centerLine(title).uppercased() + "\u{001B}[0m"
    }

    // Update the Status section
    // Composed of the player's name and
    private func updateStatus(left: [String], right: [String]) {
        lines[3] = spaceBetween(left: chooseColor(for: left[0], withTitle: left[0]), right: chooseColor(for: right[0], withTitle: right[0]))
        lines[5] = spaceBetween(left: chooseColor(for: left[1], withTitle: left[0]), right: chooseColor(for: right[1], withTitle: right[0]))
        lines[6] = spaceBetween(left: chooseColor(for: left[2], withTitle: left[0]), right: chooseColor(for: right[2], withTitle: right[0]))
        lines[7] = spaceBetween(left: chooseColor(for: left[3], withTitle: left[0]), right: chooseColor(for: right[3], withTitle: right[0]))
    }

    private func updateQuestion(with question: String) {
        lines[12] = chooseColor(for: spaceAfter(question))
        lines[13] = spaceAfter(">")
    }

    private func centerLine(_ line: String) -> String {
        // The available space is 58 characters
        // Centering text means splitting what's left in half
        let paddingSize = (58 - line.count) / 2
        let leftPadding = String(repeating: " ", count: paddingSize)
        return (leftPadding + line).padding(toLength: 58, withPad: " ", startingAt: 0)
    }

    private func spaceBetween(left: String, right: String) -> String {
        // The available space is 58 characters
        // Add 9 characters for each string to the padding (escaped characters for color)
        // Splitting text means putting what's left in the middle
        let paddingSize = (76 - left.count - right.count)
        let padding = String(repeating: " ", count: paddingSize)
        return left + padding + right
    }

    private func spaceAfter(_ line: String) -> String {
        // The available space is 58 characters
        // We need to complete line with spaces
        let paddingSize = (58 - line.count)
        let padding = String(repeating: " ", count: paddingSize)
        return line + padding
    }

    private func chooseColor(for line: String, withTitle title: String? = nil) -> String {
        var team: String
        if let unwrappedTitle = title {
            team = unwrappedTitle
        } else {
            team = self.title
        }

        if line.contains(" 00 /") { return "\u{001B}[91m" + line + "\u{001B}[0m" }
        if team.contains(game!.players.first!.name) { return "\u{001B}[34m" + line + "\u{001B}[0m" }
        if team.contains(game!.players.last!.name) { return "\u{001B}[35m" + line + "\u{001B}[0m" }

        return "\u{001B}[97m" + line + "\u{001B}[0m"
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
        / /\\ \\/                                                                \\ \\/\\ \\
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
        """)
    }

    private func resetDisplay(display: String = "Normal") {
        lines = Array(repeating: String(repeating: " ", count: 58), count: 14)

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
        print("\u{1B}[22;13H", terminator: "")
    }
}
