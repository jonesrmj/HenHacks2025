//
//  ContentView.swift
//  PassMate
//
//  Created by Ryan Jones on 3/1/25.
//

import SwiftUI

struct ContentView: View {
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  @Environment(\.colorScheme) var colorScheme
  
  @State var password: String = ""
  @State var respondeMessage: String = ""
  
  var body: some View {
    GeometryReader { geometry in
      let isLandscape = geometry.size.width > geometry.size.height
      let isWideScreen = horizontalSizeClass == .regular // Detects iPad/Mac
      
      ScrollView {
        if isLandscape || isWideScreen {
          // iPad/Mac
          
        } else {
          // iPhone
          VStack {
            ZStack {
              RoundedRectangle(cornerRadius: 20)
                .fill(Color("systemBackground"))
                .overlay(
                  RoundedRectangle(cornerRadius: 20)
                    .stroke(colorScheme == .dark ? Color.white.opacity(0.2) : Color.gray.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.5 : 0.1), radius: 10, x: 0, y: 5)
              
              VStack {
                Image("PassWarrior Logo")
                  .resizable()
                  .frame(width: 124, height: 124)
                  .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.5 : 0.1), radius: 10, x: 0, y: 5)
                  .padding(.top, 20.0)
                
                Text("PassWarrior")
                  .font(.title)
                  .bold()
                  .padding(.top, 10.0)
                
                Text("Your trusted companion for Password Security!")
                  .font(.title3)
                  .padding(.top, 0.25)
                  .padding(.bottom, 20.0)
              }
              .multilineTextAlignment(.center)
            }
            .padding(.all, 20.0)
            
            ZStack {
              RoundedRectangle(cornerRadius: 20)
                .fill(Color("systemBackground"))
                .overlay(
                  RoundedRectangle(cornerRadius: 20)
                    .stroke(colorScheme == .dark ? Color.white.opacity(0.2) : Color.gray.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.5 : 0.1), radius: 10, x: 0, y: 5)
              
              VStack {
                Text("Password Checkup")
                  .font(.title2)
                  .bold()
                  .padding(.top, 20.0)
                
                Text("Enter a password to check its strength, verify if it has appeared in any data leaks, and receive additional feedback.")
                  .font(.body)
                  .padding(.all, 10.0)
                
                TextField("Enter a Password", text: self.$password)
                  .padding(.leading, 10.0)
                  .padding(.trailing, 10.0)
                  .padding(.bottom, 10.0)
                
                Button {
                  PasswordAnalyzer.analyzePassword(password: self.password) { response in
                    print(response)
                  }
                } label: {
                  Text("Analyze")
                }
                .padding(.bottom, 20.0)
              }
              .multilineTextAlignment(.center)
            }
            .padding(.leading, 20.0)
            .padding(.trailing, 20.0)
          }
        }
      }
    }
  }
}

#Preview {
  ContentView()
}
