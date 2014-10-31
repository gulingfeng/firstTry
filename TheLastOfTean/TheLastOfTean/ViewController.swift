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
        var appFrame = GameUtil.shared.appFrame
        var x = appFrame.x
        var y = appFrame.y
        var width = appFrame.width
        var height = appFrame.height
        
        
        mainBack.frame = CGRect(x: x*0.01, y: y*0.01, width: width*0.98, height: height*0.98)
        self.view.addSubview(mainBack)
        var newDayBack = UIImageView(image: UIImage(named: "new_day_back.png"))
        newDayBack.frame = CGRect(x: x*0.02, y: y*0.02, width:width*0.96, height: height*0.96)
        self.view.addSubview(newDayBack)
        
        var labelBack = UIImageView(image: UIImage(named: "label_back.png"))
        labelBack.frame = CGRect(x: x*0.02, y: y*0.35, width:width*0.96, height: appFrame.height*0.30)
        labelBack.alpha = 0.5
        self.view.addSubview(labelBack)
        
        GameUtil.shared.printDebugInfo("current turn: \(GameBasicInfo.shared.currentTurn)")
        var dayLabel = UILabel()
        dayLabel.text = "第 \(GameBasicInfo.shared.currentTurn) 天"
        dayLabel.frame = CGRect(x: x*0.45, y:y*0.40, width: width*0.2, height: height*0.1)
        self.view.addSubview(dayLabel)
        
        var button = UIButton()
        button.layer.borderWidth = 1;
        button.layer.borderColor = UIColor.blackColor().CGColor
        button.layer.cornerRadius = 5;
        button.backgroundColor = UIColor.whiteColor()
        button.setTitleColor(UIColor.blueColor(), forState: .Normal)
        button.frame = CGRect(x: x*0.45, y: y*0.70, width: width*0.10, height: height*0.05)
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

