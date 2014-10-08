//
//  ViewController.swift
//  TheLastOfTean
//
//  Created by gulingfeng on 14-9-27.
//  Copyright (c) 2014年 gulingfeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var mainBack = UIImageView(image: UIImage(named: "main_back.png"))
        var appFrame = UIScreen.mainScreen().applicationFrame
        mainBack.frame = CGRect(x: appFrame.minX, y: appFrame.minY, width: appFrame.width, height: appFrame.height)
        self.view.addSubview(mainBack)
        GameUtil.shared.printDebugInfo("ViewController appframe:\(appFrame)")
        GameUtil.shared.printDebugInfo(UIScreen.mainScreen().bounds)
        
        var newDayBack = UIImageView(image: UIImage(named: "new_day_bak.png"))
        newDayBack.frame = CGRect(x: appFrame.minX+5, y: appFrame.minY+5, width:appFrame.width-10, height: appFrame.height-10)
        self.view.addSubview(newDayBack)
        var dayLabel = UILabel()
        dayLabel.text = "第 20 天"
        dayLabel.frame = CGRect(x: appFrame.minX+264, y: appFrame.minY+130, width: 100, height: 20)
        self.view.addSubview(dayLabel)
        var button = UIButton()
        button.layer.borderWidth = 1;
        button.layer.borderColor = UIColor.blackColor().CGColor
        button.layer.cornerRadius = 5;
        button.backgroundColor = UIColor.whiteColor()
        button.setTitleColor(UIColor.blueColor(), forState: .Normal)
        button.frame = CGRect(x: appFrame.minX+264, y: appFrame.minY+180, width: 60, height: 20)
        button.addTarget(self, action: "showEventPage", forControlEvents: .TouchUpInside)
        button.setTitle("开始", forState: .Normal)
        
        self.view.addSubview(button)
    }

    func showEventPage()
    {
        var vc = showEvent()
        self.presentViewController(vc, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

