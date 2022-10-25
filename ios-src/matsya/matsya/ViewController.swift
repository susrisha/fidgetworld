//
//  ViewController.swift
//  matsya
//
//  Created by Naresh Kumar Devalapally on 10/10/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func sendMessage(_ sender: Any) {
        BLEHandler.shared.startScanning()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
}

