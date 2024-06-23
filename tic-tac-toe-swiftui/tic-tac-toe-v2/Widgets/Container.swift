//
//  Container.swift
//  tic-tac-toe-v2
//
//  Created by Guerin Steven Colocho Chacon on 22/06/24.
//

import SwiftUI


typealias OnTap = (Int)->Void
struct Container:View {
    var height:Double = 10
    var width:Double = 10
    var onTap:OnTap
    var color:Color
    var index:Int
    init(height: Double, width: Double,  color: Color,index:Int,onTap:@escaping OnTap) {
        self.height = height
        self.width = width
        self.onTap = onTap
        self.color = color
        self.index = index
    }
    
    var body: some View {
        RoundedRectangle(cornerSize: CGSize(width: 25, height: 25))
            .frame(width: width, height: height)
            .foregroundColor(color)
//            .padding(/*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
      
            .onTapGesture {
                onTap(index)
            }
    }
}

#Preview {
    ContentView()
}
