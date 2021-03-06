//
//  consolePrintFactory.swift
//  FrenchGameFactory
//
//  Created by Lomig Enfroy on 26/04/2020.
//  Copyright © 2020 Lomig Enfroy. All rights reserved.
//

import Foundation

class ConsolePrintFactory: PrintFactory {
    var currentPlayer: PlayerTurn = .player1
    private var lines: [String] = Array(repeating: String(repeating: " ", count: 58), count: 15)
    private var backupLines : [String] = []
    private var players: [String] = Array(repeating: String(repeating: " ", count: 27), count: 2)
    private var characters: [[String]] = Array(repeating: Array(repeating: String(repeating: " ", count: 27), count: 3), count: 2)

    static  let shared: PrintFactory = ConsolePrintFactory()


    // Make the init private to avoid instanciation
    // We want this class to be a singleton used through PrintFactory.shared
    private init(){}

    //---------------------------------------------------------------------------
    //
    //   PUBLIC INTERFACE
    //
    //---------------------------------------------------------------------------

    // Print a question and its prompt at the bottom of the screen.
    // The question may be colorized to remind the User of the active Team.
    func askUser(question: String, colorize: Bool = false) {
        var color: Color = .white
        if colorize {
            color = currentPlayer.rawValue == 0 ? .blue : .purple
        }

        updateQuestion(with: question, color: color)
        display()
    }

    func hideQuestionSection() {
        lines[13] = padLine("", lineType: .fullLine)
        lines[14] = padLine("", lineType: .fullLine)

        display()
    }

    // Print a title at Top, Center of the screen
    func changeTitle(with title: String, colorize: Bool = false) {
        var color: Color = .white
        if colorize {
            color = currentPlayer.rawValue == 0 ? .blue : .purple
        }

        updateTitle(with: title, color: color)

        display()
    }

    // Print the Team name, in a Status Title Bar
    func showPlayerName(forPlayer playerIndex: Int, name: String) {
        let paddedName: String = name.padding(toLength: 17, withPad: " ", startingAt: 0)
        let playerStatus: String = "\(paddedName) DMG    HP"
        let color: Color = playerIndex == 0 ? .blue : .purple

        players[playerIndex] = colorString(padLine(playerStatus), color: color)
        updateStatus()

        display()
    }

    // Print a character in the form of:
    //     INDEX NAME       DAMAGE  HP/TOTAL_HP
    // A name that is too long will be cut
    // Number have leading 0s
    // We colorize the line to match the current status:
    //     - Red if the character is dead
    //     - Yellow if selected (is attacker waiting for a target)
    //     - The colour of its team otherwise
    func showCharacter(fromPlayer playerIndex: Int, ofIndex characterIndex: Int, name: String, damage: Int, currentHitPoints: Int, maxHitPoints: Int, isAlive: Bool, isHighlighted: Bool) {
        let id: Int = characterIndex + 1
        let paddedName: String = name.padding(toLength: 15, withPad: " ", startingAt: 0)
        let paddedDamage: String = String(format: "%03d", damage)
        let hitPoints: String = "\(String(format: "%02d", currentHitPoints))/\(maxHitPoints)"
        let characterInfo: String = "\(id) \(paddedName) \(paddedDamage) \(hitPoints)"
        let color: Color


        // if ... else if ... else was cumbersome, switching to pattern matching, functional style!
        switch (isAlive, isHighlighted, playerIndex) {
        case (false, _, _): color = .red
        case (_, true, _): color = .yellow
        case (_, _, 0): color = .blue
        default: color = .purple
        }

        characters[playerIndex][characterIndex] = colorString(padLine(characterInfo), color: color)
        updateStatus()

        display()
    }

    // Add information lines
    // Argument being an array of string
    func informUser(description: [String], color: Color? = nil) {
        description.forEach { string in
            informUser(description: string, color: color)
        }
    }
    // Argument being a single string
    func informUser(description: String, color: Color? = nil) {
        updateDescription(with: description, color: color)

        display()
    }

    // Display the Chest drawing with the message
    // Containing what's in the Chest
    func openChest(for characterName: String, content: [String]) {
        setChestDisplay()
        updateTitle(with: "\(characterName) found a treasure!", color: .yellow)

        lines[3] = padLine("Woot! Just before their attack,", lineType: .treasureLine)
        lines[4] = padLine("\(characterName) found a treasure!", lineType: .treasureLine)

        let cutName: [String] = cut(content[0], lineType: .treasureLine)
        lines[6] = colorString(padLine(cutName[0], lineType: .treasureLine), color: .red)
        lines[7] = colorString(padLine(cutName[1], lineType: .treasureLine), color: .red)

        lines[9] = padLine("(Damage: \(content[1]))", lineType: .treasureLine)

        let cutComparison: [String] = cut(content[2], lineType: .fullLine)
        lines[11] = padLine(cutComparison[0], lineType: .fullLine)
        lines[12] = padLine(cutComparison[1], lineType: .fullLine)

        lines[14] = colorString(padLine("Do you want to replace it (Yes / No)?", lineType: .fullLine), color: .green)
    }

    func displayChest(retry: Bool = false) {
        if retry {
            lines[14] = colorString(padLine("I don't understand; Yes or No?", lineType: .fullLine), color: .green)
        }

        clearScreen()
        header()
        treasureChest()
        footer()
        cursorToPosition(forTreasureDisplay: true)
    }

    func closeChest() {
        lines = backupLines
        display()
    }

    //---------------------------------------------------------------------------
    //
    //   PRIVATE FUNCTIONS
    //
    //---------------------------------------------------------------------------


    // Display on console the different lines setup beforehand
    private func display() {
        clearScreen()
        header()
        innerText()
        footer()
        cursorToPosition()
    }

    // Change Title Line
    private func updateTitle(with title: String, color: Color) {
        lines[0] = "\u{001B}[1m" + colorString(centerLine(title).uppercased(), color: color)  + "\u{001B}[0m"
    }

    // Update the Status Section
    // Composed of the player's name, weapon damage, and hit points
    private func updateStatus() {
        lines[3] = players.first! + "    " + players.last!

        (0...2).forEach { i in
            lines[i + 5] = characters.first![i] + "    " + characters.last![i]
        }
    }

    // Update the Description Section
    // A new description "pushes" former ones up
    private func updateDescription(with description: String, color boxedColor: Color?) {
        let color: Color = boxedColor ?? .white

            lines[9] = lines[10]
            lines[10] = lines[11]
            lines[11] = colorString(padLine(description, lineType: .fullLine), color: color)
    }

    // Update the Question Section
    private func updateQuestion(with question: String, color: Color) {
        lines[13] = colorString(padLine(question, lineType: .fullLine), color: color)
        lines[14] = padLine(">", lineType: .fullLine)
    }

    // Save what's on display
    // Display the Treasure display instead
    private func setChestDisplay() {
        backupLines = lines
        resetDisplayLinesForChest()
    }

    // Erase all previous text, then use smaller empty lines to let some space for
    // the template with the nice Chest drawing
    private func resetDisplayLinesForChest() {
        lines = Array(repeating: String(repeating: " ", count: 58), count: 15)

        (1...9).forEach { i in
            lines[i] = String(repeating: " ", count: 39)
        }
    }

    //---------------------------------------------------------------------------
    //
    //   HELPER FUNCTIONS
    //
    //---------------------------------------------------------------------------


    // If a line is too long, we want to cut it.
    // For aesthetic reasons, we want to keep the first line as long as possible.
    // We find the last character that can fit on the line (according to its LineType giving its length)
    // Then we cut the string on the first space before this character
    private func cut(_ string: String, lineType: LineType) -> [String] {
        if string.count <= lineType.rawValue { return [string, ""] }

        let lastSpaceOffset: Int = (1...lineType.rawValue).reversed().first { offset in
            let index: String.Index = string.index(string.startIndex, offsetBy: offset)
            return string[index...index] == " "
        }!

        let lastSpaceIndex: String.Index = string.index(string.startIndex, offsetBy: lastSpaceOffset + 1)

        return [String(string[..<lastSpaceIndex]), String(string[lastSpaceIndex...])]
    }

    // To place the End of Line decorators at the right place, we need to pad each line of text with white spaces
    // The padding depends on the available space, different according to the context.
    // This context is represented by an enum, LineType.
    private func padLine(_ line: String, lineType: LineType = .halfLine) -> String {
        return line.padding(toLength: lineType.rawValue, withPad: " ", startingAt: 0)
    }

    private func centerLine(_ line: String) -> String {
        // The available space is 58 characters
        // Centering text means splitting what's left in half
        let paddingSize: Int = (58 - line.count) / 2
        let leftPadding: String = String(repeating: " ", count: paddingSize)
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
         / /\\/ /     __________      \(lines[1])  \\ \\/ /\\
        / /\\ \\/     /\\____;;___\\     \(lines[2])   \\ \\/\\ \\
        \\ \\/\\ \\    | /         /     \(lines[3])   /\\ \\/ /
         \\/ /\\ \\   `. ())oo() .      \(lines[4])  / /\\/ /
         / /\\/ /    |\\(%()*^^()^\\    \(lines[5])  \\ \\/ /\\
        / /\\ \\/    %| |-%-------|    \(lines[6])   \\ \\/\\ \\
        \\ \\/\\ \\   % \\ | %  ))   |    \(lines[7])   /\\ \\/ /
         \\/ /\\ \\  %  \\|%________|    \(lines[8])  / /\\/ /
         / /\\/ /   %%%%              \(lines[9])  \\ \\/ /\\
        / /\\ \\/   \(lines[10])   \\ \\/\\ \\
        \\ \\/\\ \\   \(lines[11])   /\\ \\/ /
         \\/ /\\ \\  \(lines[12])  / /\\/ /
         / /\\/ /  \(lines[13])  \\ \\/ /\\
        / /\\ \\/   \(lines[14])   \\ \\/\\ \\
        """)
    }

    private func clearScreen() {
        // Clear Screen
        print("\u{1B}[2J", terminator: "")
        // Position the cursor on the second line, first column
        print("\u{1B}[2;1H", terminator: "")
    }

    // Position the cursor on the right line for user's input
    private func cursorToPosition(forTreasureDisplay treasureDisplay: Bool = false) {
        if treasureDisplay { return print("\u{1B}[23;50H", terminator: "") }

        print("\u{1B}[23;13H", terminator: "")
    }
}

enum Color: String {
    case green = "\u{001B}[32m"
    case yellow = "\u{001B}[33m"
    case blue = "\u{001B}[34m"
    case purple = "\u{001B}[35m"
    case white = "\u{001B}[37m"
    case red = "\u{001B}[91m"

}

enum LineType: Int {
    case halfLine = 27
    case treasureLine = 39
    case fullLine = 58
}
