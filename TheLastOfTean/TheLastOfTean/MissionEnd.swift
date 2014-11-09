//
//  MissionEnd.swift
//  TheLastOfTean
//
//  Created by gulingfeng on 14-11-5.
//  Copyright (c) 2014年 gulingfeng. All rights reserved.
//

import Foundation

import UIKit

class MissionEnd: SceneViewController {
    
    var info = UILabel()
    var dayLabel = UILabel()
    var propertys = [SceneWebLabel]()
    var actionButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var mainBack = UIImageView(image: UIImage(named: "main_back_fire.png"))
        var appFrame = GameUtil.shared.appFrame
        mainBack.frame = CGRect(x: appFrame.x*0.01, y: appFrame.y*0.01, width: appFrame.width*0.98, height: appFrame.height*0.98)
        self.view.addSubview(mainBack)
        println("showEvent appFrame: \(appFrame)")
        println("showEvent bounds: \(UIScreen.mainScreen().bounds)")
        
        var infoBack = UIImageView(image: UIImage(named: "label_back.png"))
        infoBack.frame = CGRect(x: appFrame.x*0.02, y: appFrame.y*0.78, width:appFrame.width*0.96, height: appFrame.height*0.20)
        infoBack.alpha = 0.5
        self.view.addSubview(infoBack)
        var mainBase = GameUtil.shared.loadMainBase()
        
        info.textAlignment = .Center
        info.frame = CGRect(x: appFrame.x*0.03, y: appFrame.y*0.85, width: appFrame.width*0.98, height: appFrame.height*0.15)
        self.view.addSubview(info)
        
        println(info.font)
        dayLabel.text = "第 \(GameBasicInfo.shared.currentTurn) 天"
        //dayLabel.font = UIFont.systemFontOfSize(15)
        dayLabel.frame = CGRect(x: appFrame.x*0.021, y: appFrame.y*0.021, width: appFrame.width*0.2, height:appFrame.height*0.10)
        self.view.addSubview(dayLabel)
        
        
        actionButton.layer.borderWidth = 1;
        actionButton.layer.borderColor = UIColor.blackColor().CGColor
        actionButton.layer.cornerRadius = 5;
        actionButton.backgroundColor = UIColor.whiteColor()
        actionButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        actionButton.frame = CGRect(x: appFrame.x*0.90, y: appFrame.y*0.03, width: appFrame.width*0.10, height: appFrame.height*0.05)
        actionButton.addTarget(self, action: "endDay", forControlEvents: .TouchUpInside)
        actionButton.setTitle("休息", forState: .Normal)
        self.view.addSubview(actionButton)
        
                
    }
    
    
    func endDay()
    {
        //self.view.removeFromSuperview()
        GameBasicInfo.shared.currentTurn++
        var dayStart = ViewController()
        self.presentViewController(dayStart, animated: true, completion: nil)
        self.view.removeFromSuperview()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        
        
        
    }
    
    
    
    
}