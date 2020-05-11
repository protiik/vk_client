//
//  SettingsViewController.swift
//  loginForm
//
//  Created by prot on 25/02/2020.
//  Copyright © 2020 prot. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var loadView1: UIView!
    @IBOutlet weak var loadView2: UIView!
    @IBOutlet weak var loadView3: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadView()
        
    }
    
    func downloadView () {
        loadView1.layer.cornerRadius = 10
        loadView2.layer.cornerRadius = 10
        loadView3.layer.cornerRadius = 10
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.loadView1.alpha = 0.5
    
        })
        UIView.animate(withDuration: 0.4, delay: 0.2, options: [.repeat, .autoreverse], animations: {
            self.loadView2.alpha = 0.5
            
            
        })
        UIView.animate(withDuration: 0.4, delay: 0.3, options: [.repeat, .autoreverse], animations: {
            self.loadView3.alpha = 0.5
        
            
        })
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func exit(unwindSegue: UIStoryboardSegue) {
    print("Welocme back")
    }
    
}
