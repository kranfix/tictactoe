//
//  LoginView.swift
//  tic-tac-toe-v2
//
//  Created by Guerin Steven Colocho Chacon on 23/06/24.
//

import Foundation
import SwiftUI

struct LoginView:View {
    var body: some View {
        ZStack{
            Color.backgroundColorClear.ignoresSafeArea()
            
            ZStack{
                
                Image("rectangle-image")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 250)
                    .position(x: 10, y: 280)
                
                Image("star-image")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 250)
                    .position(x: 350, y: 680)
                
                Image("circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 200)
                    .position(x: 300, y: 0)
                VStack{
                  
                    
                    Spacer()
                    Text("Tic Tac Toe")
                        .font(.system(size: 40, design: .rounded).monospaced())
                        .fontWeight(.bold)
                    Text("A Clasic Game")
                        .font(.system(size: 20, design: .rounded).monospaced())
                        .fontWeight(.light)
                    Spacer().frame(height: 100)
                    PrimaryButton(title: "Play") {
                        print("")
                    }
                    Spacer()
                }
                    
            }
        }
    }
}


#Preview {
    LoginView()
}

@Observable
  class Sample{
    var counter:Int = 0
      
}
