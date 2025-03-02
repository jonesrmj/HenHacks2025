//
//  PasswordAnalyzer.swift
//  PassMate
//
//  Created by Ryan Jones on 3/1/25.
//

import Foundation

struct PasswordAnalysisResult {
  let strength: String
  let breaches: String
  let aiAdvice: NSAttributedString
}

class PasswordAnalyzer {
  static func analyzePassword(password: String, completion: @escaping (PasswordAnalysisResult) -> Void) {
    guard let url = URL(string: "http://127.0.0.1:8000/API/") else {
      completion(PasswordAnalysisResult(strength: "Error", breaches: "Invalid URL", aiAdvice: NSAttributedString(string: "N/A")))
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let jsonBody: [String: Any] = ["password": password]
    do {
      request.httpBody = try JSONSerialization.data(withJSONObject: jsonBody, options: [])
    } catch {
      completion(PasswordAnalysisResult(strength: "Error", breaches: "JSON Error", aiAdvice: NSAttributedString(string: "N/A")))
      return
    }
    
    let session = URLSession.shared
    session.dataTask(with: request) { data, _, error in
      if let error = error {
        completion(PasswordAnalysisResult(strength: "Error", breaches: error.localizedDescription, aiAdvice: NSAttributedString(string: "N/A")))
        return
      }
      
      if let data = data {
        do {
          if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            let aiAdviceString = jsonResponse["AI"] as? String ?? "No suggestions"
            
            // Use the extension to convert the AI advice HTML string into an NSAttributedString
            let aiAdviceAttributed = aiAdviceString.attributedHtmlString ?? NSAttributedString(string: aiAdviceString)

            let result = PasswordAnalysisResult(
              strength: jsonResponse["strength"] as? String ?? "Unknown",
              breaches: jsonResponse["breaches"] as? String ?? "Unknown",
              aiAdvice: aiAdviceAttributed
            )
            completion(result)
          } else {
            completion(PasswordAnalysisResult(strength: "Error", breaches: "Parsing Error", aiAdvice: NSAttributedString(string: "N/A")))
          }
        } catch {
          completion(PasswordAnalysisResult(strength: "Error", breaches: "Parsing Error", aiAdvice: NSAttributedString(string: "N/A")))
        }
      }
    }.resume()
  }
}

extension String {
  var attributedHtmlString: NSAttributedString? {
    try? NSAttributedString(
      data: Data(utf8),
      options: [
        .documentType: NSAttributedString.DocumentType.html,
        .characterEncoding: String.Encoding.utf8.rawValue
      ],
      documentAttributes: nil
    )
  }
}
