//
//  APIRequest.swift
//  WeatherAPISample
//
//  Created by 이재웅 on 2022/09/17.
//

import Foundation

struct ResponseTest: Codable {
    let success: Bool
    let result: String
    let message: String
}

// Body가 없는 요청
func requestGet(url: String, completionHandler: @escaping (Bool, Any) -> Void) {
    guard let url = URL(string: url) else {
        print("Error: cannet create URL")
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard error == nil else {
            print("Error: error calling GET")
            print(error!)
            return
        }
        
        guard let data = data else {
            print("Error: Did not receive data")
            return
        }
        
        guard let response = response as? HTTPURLResponse, (200..<300) ~= response.statusCode else {
            print("Error: HTTP request failed")
            return
        }
        
        guard let output = try? JSONDecoder().decode(Weather.self, from: data) else {
            print("Error: JSON data Parsing failed")
            return
        }
        
        completionHandler(true, output.response)
    }.resume()
}

// Body가 있는 요청
func requestPost(url: String, method: String, param: [String: Any], completionHandler: @escaping (Bool, Any) -> Void) {
    
}

// 메소드별 동작 분리
func request(_ url: String, _ method: String, _ param: [String: Any]? = nil, completionHandler: @escaping (Bool, Any) -> Void) {
    if method == "GET" {
        requestGet(url: url) { (success, data) in
            completionHandler(success, data)
        }
    } else {
        requestPost(url: url, method: method, param: param!) { (sucess, data) in
            completionHandler(sucess, data)
        }
    }
    
}
