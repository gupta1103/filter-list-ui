//
//  File.swift
//  DisplayFilterUI_v2
//
//  Created by Akanksha Gupta on 03/08/21.
//

import Foundation

class APIService: NSObject {
        
    func fetchProductDetails(completion: @escaping (FilterModel?) -> Void) {
        
        let urlString = "https://jsonkeeper.com/b/P419"
        let url = URL(string: urlString)
        let task = URLSession.shared.dataTask(with: url!) { data, urlResponse, error in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(FilterModel.self, from: data)
                    DispatchQueue.main.async {
                        completion(result)
                    }
                }
                catch{
                    print("Error: \(error)")
                }
            }
        }
        task.resume()
    }
}

