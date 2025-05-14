//
//  UserProgress.swift
//  PocketWords
//
//  Created by Ashkan Ghaderi on 2/24/1404 AP.
//

import SwiftData
import Foundation

@Model
final class UserProgress{
    var totalXP: Int
    var lastUpdated: Date

    init(totalXP: Int = 0, lastUpdated: Date = Date()) {
        self.totalXP = totalXP
        self.lastUpdated = lastUpdated
    }

    func addXP(_ amount: Int) {
        totalXP += amount
        lastUpdated = Date()
    }
}
