//
//  PasswordAnalyzer.swift
//  PassMate
//
//  Created by Ryan Jones on 3/1/25.
//

import Foundation

class PasswordAnalyzer {
  static func analyzePassword(password: String, completion: @escaping (String) -> Void) {
    // Backend API URL
    guard let url = URL(string: "") else {
      print("Invalid URL")
      completion("Invalid URL")
      return
    }
    
    // Create the request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // JSON body
    let jsonBody: [String: Any] = [
      "password": password
    ]
    
    do {
      // Encode the JSON body
      let jsonData = try JSONSerialization.data(withJSONObject: jsonBody, options: [])
      request.httpBody = jsonData
    } catch {
      print("Error encoding JSON: \(error)")
      completion("Error encoding JSON")
      return
    }
    
    // Create a URL Session to handle the request
    let session = URLSession.shared
    session.dataTask(with: request) { data, response, error in
      // Handle the response
      if let error = error {
        completion("Error: \(error.localizedDescription)")
        return
      }
      
      // Check for a valid response
      if let data = data {
        do {
          // Assuming the backend returns a JSON object with a "message" field
          let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
          let message = jsonResponse?["message"] as? String ?? "Unknown response"
          
          // Call the completion handler with the response message
          completion(message)
        } catch {
          completion("Error parsing response")
        }
      }
    }.resume()
  }
}
