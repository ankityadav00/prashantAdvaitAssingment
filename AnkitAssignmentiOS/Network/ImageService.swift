//
//  ImageService.swift
//  AnkitAssignmentiOS
//
//  Created by Ankit yadav on 15/04/24.
//

import Foundation

class ImageService {
    func fetchImage(completion: @escaping (ImageDataModel?, Error?) -> Void) {
        guard let url = URL(string: "https://acharyaprashant.org/api/v2/content/misc/media-coverages?limit=100") else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(nil, NSError(domain: "Invalid response", code: 0, userInfo: nil))
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "No data", code: 0, userInfo: nil))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let imageResponse = try decoder.decode(ImageDataModel.self, from: data)
                completion(imageResponse, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
}
