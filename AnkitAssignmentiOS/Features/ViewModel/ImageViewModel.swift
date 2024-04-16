//
//  ImageViewModel.swift
//  AnkitAssignmentiOS
//
//  Created by Ankit yadav on 15/04/24.
//

import Foundation


class ImageViewModel: ObservableObject {
    var items: [ImageDataModel] = []
    
    func fetchData(completion: @escaping ([ImageDataModel]?, Error?) -> Void) {
        guard let url = URL(string: "https://acharyaprashant.org/api/v2/content/misc/media-coverages?limit=100") else {
            print("Invalid URL")
            completion(nil, NSError(domain: "InvalidURL", code: 0, userInfo: nil))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data returned: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil, error)
                return
            }
            
            do {
                let items = try JSONDecoder().decode([ImageDataModel].self, from: data)
                DispatchQueue.main.async {
                    self.items = items
                    completion(items, nil)
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion(nil, error)
            }
        }.resume()
    }
}
