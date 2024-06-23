//
//  ContentView.swift
//  tic-tac-toe-v2
//
//  Created by Guerin Steven Colocho Chacon on 22/06/24.
//


import SwiftUI
import SwiftCBOR

struct ContentView: View {
 
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    @State var currentIndex:Int? = nil
    
    var body: some View {
        ZStack{
            Color.backgroundColorClear.ignoresSafeArea()
            VStack{
           
                   
                
                LazyVGrid(columns: columns) {
                    ForEach(0...8, id: \.self) { index in
                        Container(height: 110, width: 100,color:currentIndex == index ?  .player1 : .box, index: index) { currentIndex in
                            withAnimation(.spring()) {
                                self.currentIndex = currentIndex
                            }
                       
                        }
                        .padding([.bottom], 8)
                            
                    }
                }
                
                
               
            }
            .padding()
        }
    }
       

}




#Preview {
    ContentView()
       
}





