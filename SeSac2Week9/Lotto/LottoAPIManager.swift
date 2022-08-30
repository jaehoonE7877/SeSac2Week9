//
//  LottoAPIManager.swift
//  SeSac2Week9
//
//  Created by Seo Jae Hoon on 2022/08/30.
//

import Foundation

//shared - 일반적인 네트워크 통신, 단순한 통신, 커스텀X
//URLSession.init(configuration: .default) - shared와 비슷하나 커스텀을 하고자할 때 사용, 응답은 custom(셀룰러 연결 여부), delegate로 할 수 있다.

/*
 URLSession -> shared(일반적), init(configuration: ) (커스텀 default, background)
 DataTask   -> DataTask, UploadTask, DownloadTask
 Response   -> handler, Delegate
 */

enum APIError: Error {
    case invalidResponse
    case noData
    case failedRequest
    case invalidData
}

class LottoAPIManager {
    
    static func requestLotto(drwNo: Int, completion: @escaping (Lotto?, APIError?)-> Void ) {
        
        let url = URL(string: "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(drwNo)")!
        
        //let a = URLRequest(url: url)
        //a.setValue(<#T##value: String?##String?#>, forHTTPHeaderField: <#T##String#>)
        
        //URLSession.request(endpoint: <#T##URLRequest#>, completion: <#T##((Decodable & Encodable)?, APIError?) -> Void#>)
        
        let session = URLSession.shared
        
        session.dataTask(with: url) { data, response, error in

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
                    let result = try JSONDecoder().decode(Lotto.self, from: data)
                    completion(result, nil)
                } catch {
                    print(error)
                    completion(nil, .invalidData)
                }
            }

        }.resume()
    }
    
}

