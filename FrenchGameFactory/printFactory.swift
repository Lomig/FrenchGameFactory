//
//  printFactory.swift
//  FrenchGameFactory
//
//  Created by Lomig Enfroy on 09/05/2020.
//  Copyright © 2020 Lomig Enfroy. All rights reserved.
//

import Foundation

protocol PrintFactory {
    var currentPlayer: PlayerTurn { get set }
    static var shared: PrintFactory { get }

    func askUser(question: String, colorize: Bool)
    func hideQuestionSection()
    func changeTitle(with title: String, colorize: Bool)
    func showPlayerName(forPlayer playerIndex: Int, name: String)
    func showCharacter(
        fromPlayer playerIndex: Int,
        ofIndex characterIndex: Int,
        name: String,
        damage: Int,
        currentHitPoints: Int,
        maxHitPoints: Int,
        isAlive: Bool,
        isHighlighted: Bool)
    func informUser(description: [String], color: Color?)
    func informUser(description: String, color: Color?)
    func openChest(for characterName: String, content: [String])
    func displayChest(retry: Bool)
    func closeChest()
}

extension PrintFactory {
    func askUser(question: String, colorize: Bool = false) {
        return askUser(question: question, colorize: false)
    }

    func changeTitle(with title: String, colorize color: Bool = false) {
        return changeTitle(with: title, colorize: color)
    }
    func informUser(description: [String], color: Color? = nil) {
        return informUser(description: description, color: color)
    }
    func informUser(description: String, color: Color? = nil) {
        return informUser(description: description, color: color)
    }
    func displayChest(retry: Bool = false) {
        return displayChest(retry: retry)
    }
}
