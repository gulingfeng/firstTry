//
//  ViewController.swift
//  TestEvent
//
//  Created by gulingfeng on 14-9-23.
//  Copyright (c) 2014年 gulingfeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    @IBAction func start(sender: AnyObject) {
        var vc = Event()
        self.presentViewController(vc, animated: true, completion: nil)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

