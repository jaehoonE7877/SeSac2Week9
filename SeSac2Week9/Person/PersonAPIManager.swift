//
//  PersonAPIManager.swift
//  SeSac2Week9
//
//  Created by Seo Jae Hoon on 2022/08/30.
//

import Foundation

class PersonAPIManager {
    
    static func request(query: String, completion: @escaping (Person?, APIError?) -> Void) {
                
        let scheme = "https"
        let host = "api.themoviedb.org"
        let path = "/3/search/person"
        
        let language = "ko-KR"
        let key = "867e1ac4bd43064513d4cfe94848ace1"
        let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.path = path
        component.queryItems = [
            URLQueryItem(name: "api_key", value: key),
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "region", value: language)
        ]
        
        
        URLSession.shared.dataTask(with: component.url!) { data, response, error in

            DispatchQueue.main.async {
                
                guard error == nil else {
                    print("Failed Request")
                    completion(nil, .failedRequest)
                    return
                }
                
                guard let data = data else {
                    print("No Data Returned")
                    completion(nil, .noData)
                    return
                }
                
                // statuscode를 꺼내기 위해서 타입캐스팅, 옵셔널 바인딩
                guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                    print("Error: HTTP request failed")
                    completion(nil, .invalidResponse)
                    return
                }
                
                do{
                    let result = try JSONDecoder().decode(Person.self, from: data)
                    completion(result, nil)
                } catch {
                    print(error)
                    completion(nil, .invalidData)
                }
            }

        }.resume()
        
        
        
    }
}
