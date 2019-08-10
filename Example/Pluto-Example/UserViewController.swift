//
//  UserViewController.swift
//  Pluto-Example
//
//  Created by Meng Li on 2019/8/10.
//  Copyright © 2019 MuShare. All rights reserved.
//

import Pluto

class UserViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func refresh(_ sender: Any) {
        Pluto.shared.getToken { [weak self] in
            self?.showAlert(title: "token", content: $0 ?? "")
        }
    }
    
}
