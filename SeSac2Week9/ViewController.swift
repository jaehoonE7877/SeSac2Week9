//
//  ViewController.swift
//  SeSac2Week9
//
//  Created by Seo Jae Hoon on 2022/08/30.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var lottoLabel: UILabel!
    
 private var viewModel = PersonViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchPerson(query: "kim")
        
        viewModel.list.bind { person in
            print("viewcontroller bind")
            self.tableView.reloadData()
        }
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let data = viewModel.cellForRowAt(at: indexPath)
        
        cell.textLabel?.text = data.name
        cell.detailTextLabel?.text = data.knownForDepartment
        
        return cell
    }
    
    
    
    
}

