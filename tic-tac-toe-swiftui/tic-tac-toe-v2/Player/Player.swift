//
//  Player.swift
//  tic-tac-toe-v2
//
//  Created by Guerin Steven Colocho Chacon on 22/06/24.
//

import Foundation
import SwiftUI

class Player:Identifiable{
    
    var id: String = UUID().uuidString
    var color:Color
    init( color: Color) {
     
        self.color = color
    }
}
