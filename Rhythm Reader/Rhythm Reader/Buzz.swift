//
//  Buzz.swift
//  Rhythm Reader
//
//  Created by Nevin George on 4/27/18.
//  Copyright © 2018 Nevin George. All rights reserved.
//


import UIKit

class Buzz: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func back(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
