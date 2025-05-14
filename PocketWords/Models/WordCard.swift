//
//  WordCard.swift
//  PocketWords
//
//  Created by Ashkan Ghaderi on 2/24/1404 AP.
//

import SwiftData
import Foundation

@Model
final class WordCard {
    var word: String
    var meaning: String
    var createdAt: Date

    init(word: String, meaning: String, createdAt: Date = Date()) {
        self.word = word
        self.meaning = meaning
        self.createdAt = createdAt
    }
}
