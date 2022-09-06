//
//  Localizable+Extension.swift
//  SeSac2Week9
//
//  Created by Seo Jae Hoon on 2022/09/06.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    //제네릭으로 input값을 사용할 수 있음
    func localized(with: String) -> String {
        return String(format: self.localized, with)
    }
    
    func localized(number: Int) -> String {
        return String(format: self.localized, number)
    }
}
