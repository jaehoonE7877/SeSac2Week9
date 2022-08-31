//
//  PersonViewModel.swift
//  SeSac2Week9
//
//  Created by Seo Jae Hoon on 2022/08/31.
//

import Foundation
//데이터만 다루는 곳!!!
class PersonViewModel {
    
    var list: Observable<Person> = Observable(Person(page: 0, totalPages: 0, totalResults: 0, results: []))
    
    func fetchPerson(query: String) {
        
        PersonAPIManager.request(query: query) { person, error in
            guard let person = person else { return }
            self.list.value = person
        }
    }
    
    //연산 프로퍼티 ()호출 연산자 필요 없음!
    var numberOfRowsInSection: Int {
        return list.value.results.count
    }
    
    func cellForRowAt(at indexPath: IndexPath) -> Result {
        return list.value.results[indexPath.row]
    }
}
