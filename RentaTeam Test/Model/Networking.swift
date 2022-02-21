//
//  Networking.swift
//  RentaTeam Test
//
//  Created by Andrey Lobanov on 21.02.2022.
//

import Foundation
import Alamofire

class Networking {
    
    static let shared = Networking()
    
    func fetchPhotos(page: Int, completition: @escaping ([Hit]) -> Void) {
        let url = "https://pixabay.com/api/?key=25814967-30a2e5594a0dea06dd8f8ef9c&image_type=photo&q=dogs&page=\(page)"
        
        AF.request(url).responseDecodable(of: Welcome.self) { response in
            guard let result = response.value else { return }
            completition(result.hits)
        }
    }
}
