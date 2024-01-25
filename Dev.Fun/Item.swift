//
//  Item.swift
//  Dev.Fun
//
//  Created by Noura Alqahtani on 25/01/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
