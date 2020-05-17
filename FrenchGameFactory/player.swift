//
//  player.swift
//  FrenchGameFactory
//
//  Created by Lomig Enfroy on 25/04/2020.
//  Copyright © 2020 Lomig Enfroy. All rights reserved.
//

import Foundation

class Player {
    static let maxNumberOfCharacters: Int = 3
    
    let name: String

    // printFactoryIndex is used by PrintFactory to know if it should print the Player and its Characters
    // on the left or the right side of the screen.
    let printFactoryIndex: Int
    var characters: [Character] = []
    private let printFactory: PrintFactory = ConsolePrintFactory.shared

    var isWiped: Bool {
        return characters.first { character in character.isAlive } == nil
    }

    init(name: String, printFactoryIndex: Int) {
        self.name = name
        self.printFactoryIndex = printFactoryIndex
    }

    // Main Action between two characters
    func play(against opponent: Player) {
        // Choose an attacker to play with
        let attacker: Character = chooseCharacter(attackBy: self, role: .attacker)
        attacker.updateStatus(isHighlighted: true)

        // The attacker may find a chest with 40% probability
        // We do it before attacking for the flow of the game inside the console
        if Int.random(in: 1...100) <= 40 { attacker.getChest() }

        // Choose a target to play against
        let target: Character = opponent.chooseCharacter(attackBy: self, with: attacker, role: .target)
        attacker.attack(target)
    }

    // Add a new character for the player
    func addCharacter(named name: String, class heroClass: HeroClass) {

        // Using Metaprogramming
        // We get the name of the Swift class from the name of the Hero Class
        // To avoid unnecessary case switch for all types of Hero Classes
        // And to be agnostic to Hero Classes names and numbers.
        let heroClassClass = NSClassFromString("FrenchGameFactory.\(String(describing: heroClass))") as! Character.Type
        let newCharacter: Character = heroClassClass.init(name: name, printFactoryIndex: [printFactoryIndex, characters.count])
        characters.append(newCharacter)
    }

    // Check if a name is already in use in this team
    func isCharacterNameTaken(_ name: String) -> Bool {
        return characters.first { character in character.name == name } != nil
    }

    // Choose character from the User input.
    // If the input is not a number within the index, or if the character selected is already dead
    // Recursively retry
    private func chooseCharacter(attackBy player: Player, with boxedCharacter: Character? = nil, role: CharacterRole, isSecondAttempt: Bool = false) -> Character {
        if let character = boxedCharacter {
            printFactory.informUser(description: "\(character.name) attacks! (Force: \(String(format: "%02d",character.force)) — Weapon Damage: \(String(format: "%02d",character.weapon.damage)))")
        }

        printFactory.changeTitle(with: "\(player.name) is attacking!")
        printFactory.askUser(question: "\(player.name), choose your \(role.rawValue): (1-\(Player.maxNumberOfCharacters))", colorize: true)


        // Get player input to select a character
        guard let chosenValue = Int(readLine()!), chosenValue > 0, chosenValue <= Player.maxNumberOfCharacters else {
            // Error message if the input cannot lead to a character selection
            printFactory.informUser(description: "This is not a valid input. Retrying...", color: .yellow)
            return chooseCharacter(attackBy: player, role: role, isSecondAttempt: true)
        }


        // The chosen character must be alive to be selected
        // If it's the case, we return it
        if characters[chosenValue - 1].isAlive {
            if isSecondAttempt {
                printFactory.informUser(description: "Retry successful, valid character chosen!", color: .green)
            }
            return characters[chosenValue - 1]
        }

        // Error message if the character is not alive
        printFactory.informUser(description: "This character is out of combat, please try again :(", color: .red)
        return chooseCharacter(attackBy: player, role: role, isSecondAttempt: true)
    }
}

enum CharacterRole: String {
    case attacker, target
}
