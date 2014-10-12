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
        
        var newDayBack = UIImageView(image: UIImage(named: "new_day_back.png"))
        newDayBack.frame = CGRect(x: appFrame.maxX*0.01, y: appFrame.maxY*0.02, width:appFrame.width*0.98, height: appFrame.height*0.96)
        self.view.addSubview(newDayBack)
        
        var labelBack = UIImageView(image: UIImage(named: "label_back.png"))
        labelBack.frame = CGRect(x: appFrame.maxX*0.01, y: appFrame.maxY*0.35, width:appFrame.width*0.98, height: appFrame.height*0.30)
        labelBack.alpha = 0.5
        self.view.addSubview(labelBack)
        
        GameUtil.shared.printDebugInfo("current turn: \(GameBasicInfo.shared.currentTurn)")
        var dayLabel = UILabel()
        dayLabel.text = "第 \(GameBasicInfo.shared.currentTurn) 天"
        dayLabel.frame = CGRect(x: appFrame.maxX*0.45, y: appFrame.maxY*0.40, width: appFrame.width*0.2, height: appFrame.height*0.1)
        self.view.addSubview(dayLabel)
        
        var button = UIButton()
        button.layer.borderWidth = 1;
        button.layer.borderColor = UIColor.blackColor().CGColor
        button.layer.cornerRadius = 5;
        button.backgroundColor = UIColor.whiteColor()
        button.setTitleColor(UIColor.blueColor(), forState: .Normal)
        button.frame = CGRect(x: appFrame.maxX*0.45, y: appFrame.maxY*0.70, width: appFrame.width*0.10, height: appFrame.height*0.05)
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

