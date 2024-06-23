//
//  Buttons.swift
//  tic-tac-toe-v2
//
//  Created by Guerin Steven Colocho Chacon on 23/06/24.
//

import SwiftUI

struct Buttons: View {
    var body: some View {
        PrimaryButton(title: "Hello world") {
            print("")
        }
    }
}

struct PrimaryButton: View {
    var title: String
    var callBack: () -> Void
    var body: some View {
        HStack {
            Button(action: { callBack() }, label: {
                Spacer()

                Text(title)
                    .foregroundStyle(.white)
                  
                
                Spacer()
            })
            .frame(width: 300,height:  50)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(.black))
            
        }
    }
}



#Preview {
    Buttons()
}
