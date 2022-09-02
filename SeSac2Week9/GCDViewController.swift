//
//  GCDViewController.swift
//  SeSac2Week9
//
//  Created by Seo Jae Hoon on 2022/09/02.
//

import UIKit

class GCDViewController: UIViewController {
    
    let url1 = URL(string: "https://apod.nasa.gov/apod/image/2201/OrionStarFree3_Harbison_5000.jpg")!
        let url2 = URL(string: "https://apod.nasa.gov/apod/image/2112/M3Leonard_Bartlett_3843.jpg")!
        let url3 = URL(string: "https://apod.nasa.gov/apod/image/2112/LeonardMeteor_Poole_2250.jpg")!
    
    @IBOutlet weak var imageFirst: UIImageView!
    @IBOutlet weak var imageSecond: UIImageView!
    @IBOutlet weak var imageThird: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    // 우리가 작성하는 모든 코드는 메인큐의 동기 작업(코드 순서대로)
    @IBAction func serialSync(_ sender: UIButton) {
        print("START")
        //
        //        for i in 1...100 {
        //            print(i, terminator: " ")
        //        }
        //
        //        DispatchQueue.main.sync {   //왜 문제가 생기는 지
        //            for i in 101...200 {
        //                print(i, terminator: " ")
        //            }
        //        }
        
        print("END")
    }
    @IBAction func serialAsync(_ sender: UIButton) {
        print("START", terminator: " ")
        
        
        for i in 1...100 {
            DispatchQueue.main.async {
                print(i, terminator: " ")
            }
        }
        
        for i in 101...200 {
            print(i, terminator: " ")
        }
        
        print("END")
    }
    @IBAction func globalSync(_ sender: UIButton) {
        print("START", terminator: " ")
        
        DispatchQueue.global().sync { // global로 sync 작업을 시키더라도 main스레드에서 sync작업을 하는 것과 마찬가지여서 swift안에서 main에서 시킨다.
            for i in 1...100 {
                print(i, terminator: " ")
            }
        }
        
        for i in 101...200 {
            print(i, terminator: " ")
        }
        
        print("END")
    }
    @IBAction func globalAsync(_ sender: UIButton) {
        print("START \(Thread.isMainThread)", terminator: " ")
        
        //        DispatchQueue.global().async {
        //            for i in 1...100 {
        //                print(i, terminator: " ")
        //            }
        //        }
        
        for i in 1...100 {
            DispatchQueue.global().async {
                print(i, terminator: " ")
            }
        }
        
        for i in 101...200 {
            print(i, terminator: " ")
        }
        
        print("END \(Thread.isMainThread)")
    }
    
    @IBAction func qos(_ sender: UIButton) {
        
        let customQueue = DispatchQueue(label: "concurrentSeSAC", qos: .userInteractive, attributes: .concurrent)
        
        customQueue.async {
            print("START")
        }
        
        for i in 1...100 {
            DispatchQueue.global(qos: .background).async {
                print(i, terminator: " ")
            }
        }
        
        
        for i in 101...200 {
            DispatchQueue.global(qos: .userInteractive).async {
                print(i, terminator: " ")
            }
        }
        
        
        for i in 201...300 {
            DispatchQueue.global(qos: .userInitiated).async {
                print(i, terminator: " ")
            }
        }
        
    }
    
    
    @IBAction func dispatchGroup(_ sender: UIButton) {
        
        let jack = DispatchGroup()
        
        DispatchQueue.global().async(group: jack) {
            for i in 1...100 {
                print(i, terminator: " ")
            }
        }
        
        DispatchQueue.global().async(group: jack) {
            for i in 101...200 {
                print(i, terminator: " ")
            }
        }
        
        DispatchQueue.global().async(group: jack) {
            for i in 201...300 {
                print(i, terminator: " ")
            }
        }
        
        jack.notify(queue: .main) {
            print("끝") //tableView.reloadData()
        }
        
    }
    
    func request(url: URL, completionHandler: @escaping (UIImage?) -> Void) {
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else {
                    completionHandler(UIImage(systemName: "star"))
                    return
                }

                let image = UIImage(data: data)
                completionHandler(image)
                                      
            }.resume()
        }
    
    @IBAction func dispatchGroupNasa(_ sender: UIButton) {
   // 이전에 사용했던 방식
//        request(url: url1) { image in
//            print("1")
//            self.request(url: self.url2) { iamge in
//                print("2")
//                self.request(url: self.url3) { image in
//                    print("3")
//                    print("끝. 갱신.")
//                }
//            }
//        }
        
        // 디스패치 그룹
        let group = DispatchGroup()
        
        DispatchQueue.global().async(group: group) {
            
            for i in 1...100 {
                print(i)
            }
            // 다른 global 큐로 들어가기 때문에 상위 글로벌 큐는 일이 끝났다고 인지함
            self.request(url: self.url1) { image in
                print("1")
            }
        }
        DispatchQueue.global().async(group: group) {
            self.request(url: self.url2) { image in
                print("2")
            }
        }
        DispatchQueue.global().async(group: group) {
            self.request(url: self.url3) { image in
                print("3")
            }
        }
        group.notify(queue: .main) {
            print("끝. 완료.")
        }
        
    }
    
    @IBAction func enterLeave(_ sender: UIButton) {
        
        let group = DispatchGroup()
        
        var imageList: [UIImage] = []
        
        group.enter()
        request(url: url1) { image in
            imageList.append(image!)
            group.leave()
        }
        
        group.enter()
        request(url: url2) { image in
            imageList.append(image!)
            group.leave()
        }
        
        group.enter()
        request(url: url3) { image in
            imageList.append(image!)
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.imageFirst.image = imageList[0]
            self.imageSecond.image = imageList[1]
            self.imageThird.image = imageList[2]
        }
    }
    //Race Condition -> 여러 스레드에서 같은 변수에 접근할 때 Thread-Safe하지 않다!
    @IBAction func raceCondition(_ sender: UIButton) {
        
        let group = DispatchGroup()
        
        var nickname = "SeSAC"
        
        DispatchQueue.global(qos: .userInteractive).async(group: group){
            nickname = "고래밥"
            print("first: \(nickname)")
        }
        
        group.notify(queue: .main) {
            print("result: \(nickname)")
        }
        
        let group2 = DispatchGroup()
        
        DispatchQueue.global(qos: .userInteractive).async(group: group2){
            nickname = "칙촉"
            print("second: \(nickname)")
        }
        
        group2.notify(queue: .main) {
            print("result: \(nickname)")
        }
        
        let group3 = DispatchGroup()
        
        DispatchQueue.global(qos: .userInteractive).async(group: group3){
            nickname = "올라프"
            print("third: \(nickname)")
        }
        
        group3.notify(queue: .main) {
            print("result: \(nickname)")
        }
    }
    
    
}
