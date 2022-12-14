//
//  LottoViewController.swift
//  SeSac2Week9
//
//  Created by Seo Jae Hoon on 2022/09/01.
//

import UIKit

class LottoViewController: UIViewController {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    @IBOutlet weak var label7: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var viewModel = LottoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.viewModel.fetchLottoApi(drwNo: 1000)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            self.viewModel.fetchLottoApi(drwNo: 1022)
        }
        
        bindData()
        
    }
    // viewModel을 view와 묶어주는 작업! view -> vm아 나 너를 구독하고 있을게!
    func bindData(){
        
        viewModel.number1.bind { value in
            self.label1.text = "\(value)"
        }
        viewModel.number2.bind { value in
            self.label2.text = "\(value)"
        }
        viewModel.number3.bind { value in
            self.label3.text = "\(value)"
        }
        viewModel.number4.bind { value in
            self.label4.text = "\(value)"
        }
        viewModel.number5.bind { value in
            self.label5.text = "\(value)"
        }
        viewModel.number6.bind { value in
            self.label6.text = "\(value)"
        }
        viewModel.number7.bind { value in
            self.label7.text = "\(value)"
        }
        
        viewModel.lottoMoney.bind { money in
            self.dateLabel.text = money
        }
        
    }

}
