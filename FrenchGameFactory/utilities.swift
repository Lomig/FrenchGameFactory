//
//  utilities.swift
//  FrenchGameFactory
//
//  Created by Lomig Enfroy on 04/05/2020.
//  Copyright © 2020 Lomig Enfroy. All rights reserved.
//

import Foundation

extension String {
    func pluralize(number: Int) -> String {
        if number == 1 || number == -1 {
            return "\(number) \(self)"
        }

        return "\(number) \(self)s"
    }
}
