//
//  Item.swift
//  tic-tac-toe-v2
//
//  Created by Guerin Steven Colocho Chacon on 22/06/24.
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
