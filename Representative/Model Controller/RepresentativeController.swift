//
//  RepresentativeController.swift
//  Representative
//
//  Created by Lo Howard on 5/16/19.
//  Copyright © 2019 Lo Howard. All rights reserved.
//

import UIKit

class RepresentativeController {
    static let baseURL = URL(string: "https://whoismyrepresentative.com/")
    
    static func searchRepresentatives(forState state: String, completion: @escaping (([Representative]) -> Void)) {
        guard var baseURL = baseURL else { return }
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        baseURL.appendPathComponent("getall_reps_bystate")
        baseURL.appendPathExtension("php")
        let queryItems = URLQueryItem(name: "state", value: state)
        components?.queryItems = [queryItems]
        guard let finalURL = components?.url else {completion([]); return }
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                completion([])
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { completion([]); return }
            do {
                guard let ascii = String(data: data, encoding: .ascii)?.data(using: .utf8) else { return }
                let newRep = try JSONDecoder().decode(Representative.self, from: ascii)
                completion([newRep])
            } catch {
                print(error.localizedDescription)
                completion([])
                return
            }
        }.resume()
    }
}
