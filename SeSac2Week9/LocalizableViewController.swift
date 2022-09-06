//
//  LocalizableViewController.swift
//  SeSac2Week9
//
//  Created by Seo Jae Hoon on 2022/09/06.
//

import UIKit
import MessageUI // 메일로 문의 보내기, 디바이스 테스트, 아이폰 메일 계정을 등록해야 가능(메일계정이 없으면 Alert을 띄워서 메일 계정을 설정해달라고 해야됨)

class LocalizableViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var maLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var sampleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //저는 고래밥입니다.
        //i am Jack. -> 메개변수가 들어갔는데 순서가 다르다면?!
        
        navigationItem.title = "navigation_title".localized
        
        maLabel.text = "introduce".localized(with: "고래밥") //서버통신 데이터 값 or Userdefaults 의 값이 들어갈 수 있음
        
        inputTextField.text = "number_test".localized(number: 11)
        
        searchBar.placeholder = "search_placeholder".localized
        
        inputTextField.placeholder = "main_age_placeholder".localized
        
        sampleButton.setTitle("common_cancel".localized, for: .normal)
        
    }
    
    func sendMail() {
        if MFMailComposeViewController.canSendMail() {
            //메일 보내기
            let mail = MFMailComposeViewController()
            mail.setToRecipients(["sjh7877@naver.com"])
            mail.setSubject("고래밥 다이어리 문의사항 -")
            mail.mailComposeDelegate = self   //
            self.present(mail, animated: true)
            
        } else {
            //alert : 메일 등록을 해주시거나 jack@jack으로 문의주세요!
            print("ALERT")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        // mail view가 떴을때 정상적으로 보내졌다. 실패했다고 Toast 띄워줄 수 있음
        // 어떤식으로 대응 할 수 있을지 생각해보기
        switch result {
        case .cancelled: //사용자가 실패
            <#code#>
        case .saved: //임시저장
            <#code#>
        case .sent: // 보내짐
            <#code#>
        case .failed: // 실패
            <#code#>
        }
        
        controller.dismiss(animated: true)
    }
    
}

