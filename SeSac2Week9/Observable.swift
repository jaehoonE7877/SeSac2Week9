//
//  Observable.swift
//  SeSac2Week9
//
//  Created by Seo Jae Hoon on 2022/08/31.
//

import Foundation

// 데이터를 담아주는 역할
// 양방향 바인딩이 가능하게끔 -> didSet 구문(데이터 바인딩)
class Observable<T> {
    
    private var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            print("didset", value)
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void ){
        print(#function)
        closure(value)
        listener = closure
    }
}

