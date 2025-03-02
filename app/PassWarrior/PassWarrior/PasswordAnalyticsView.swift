//
//  PasswordAnalyticsView.swift
//  PassMate
//
//  Created by Ryan Jones on 3/1/25.
//

import SwiftUI

class PasswordAnalyticsViewModel: ObservableObject {
  @Published var strength: String = "Analyzing..."
  @Published var breaches: String = "Checking..."
  @Published var aiAdvice: NSAttributedString = NSAttributedString(string: "Analyzing...")
  
  func analyze(password: String) {
    PasswordAnalyzer.analyzePassword(password: password) { result in
      DispatchQueue.main.async {
        self.strength = result.strength
        self.breaches = result.breaches
        self.aiAdvice = result.aiAdvice
      }
    }
  }
}

struct PasswordAnalyticsView: View {
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  @Environment(\.colorScheme) var colorScheme
  
  @StateObject private var viewModel = PasswordAnalyticsViewModel()
  
  let password: String
  
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
                Text("Password:")
                  .font(.title)
                  .bold()
                  .padding(.top, 20.0)
                  .padding(.bottom, 10.0)
                
                Text(password)
                  .font(.title2)
                  .bold()
                  .padding(.leading, 10.0)
                  .padding(.trailing, 10.0)
                  .padding(.bottom, 20.0)
              }
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
                Text("Summary:")
                  .font(.title)
                  .bold()
                  .padding(.top, 20.0)
                
                Text("Password Strength:")
                  .font(.body)
                  .padding(.all, 5.0)
                
                Text(viewModel.strength)
                  .font(.title2)
                  .bold()
                  .padding(.leading, 10.0)
                  .padding(.trailing, 10.0)
                  .padding(.bottom, 20.0)
              }
            }
            .padding(.leading, 20.0)
            .padding(.trailing, 20.0)
            .padding(.bottom, 20.0)
            
            ZStack {
              RoundedRectangle(cornerRadius: 20)
                .fill(Color("systemBackground"))
                .overlay(
                  RoundedRectangle(cornerRadius: 20)
                    .stroke(colorScheme == .dark ? Color.white.opacity(0.2) : Color.gray.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.5 : 0.1), radius: 10, x: 0, y: 5)
              
              VStack {
                Text("Data Leaks:")
                  .font(.title)
                  .bold()
                  .padding(.top, 20.0)
                
                Text(viewModel.breaches)
                  .font(.body)
                  .padding(.top, 0.25)
                  .padding(.leading, 10.0)
                  .padding(.trailing, 10.0)
                  .padding(.bottom, 20.0)
              }
            }
            .padding(.leading, 20.0)
            .padding(.trailing, 20.0)
            .padding(.bottom, 20.0)
            
            ZStack {
              RoundedRectangle(cornerRadius: 20)
                .fill(Color("systemBackground"))
                .overlay(
                  RoundedRectangle(cornerRadius: 20)
                    .stroke(colorScheme == .dark ? Color.white.opacity(0.2) : Color.gray.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.5 : 0.1), radius: 10, x: 0, y: 5)
              
              VStack {
                Text("Suggestions:")
                  .font(.title)
                  .bold()
                  .padding(.top, 20.0)
                
                Text(viewModel.aiAdvice.string)
                  .padding(.top, 0.25)
                  .padding(.leading, 10.0)
                  .padding(.trailing, 10.0)
                  .padding(.bottom, 20.0)
              }
            }
            .padding(.leading, 20.0)
            .padding(.trailing, 20.0)
          }
          .multilineTextAlignment(.center)
        }
      }
      .onAppear {
        viewModel.analyze(password: password)
      }
    }
  }
}

#Preview {
  PasswordAnalyticsView(password: "example123")
}
