//
//  Event.swift
//  TestEvent
//
//  Created by gulingfeng on 14-9-23.
//  Copyright (c) 2014年 gulingfeng. All rights reserved.
//

import Foundation
import UIkit
class Event: UIViewController {

    var backgroundImage = UIImageView()
    var backText = UILabel()
    var dialog = UILabel()
    var sceneSeq = 0
    var eventDetail: EventDetail?
    var scenes = [Scene]()
    var touch: UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        backgroundImage.image = UIImage(named:"z-01.png")
        backgroundImage.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().applicationFrame.width, height: UIScreen.mainScreen().applicationFrame.height)
        backgroundImage.userInteractionEnabled = true
        touch = UITapGestureRecognizer(target: self, action: "changeEvent:")
        backgroundImage.addGestureRecognizer(touch)
        backText.text = "z-01"
        backText.frame = CGRect(x: 50, y: 50, width: 100, height: 30)

        self.view.addSubview(backgroundImage)
        self.view.addSubview(backText)
        dialog.text = "dialog z-01"
        dialog.textColor = UIColor.redColor()
        dialog.frame = CGRect(x: 50, y: 250, width: 100, height: 30)
        self.view.addSubview(dialog)
        prepareEvent()
        showDefaultEventDetail()
        var c = 0
        for i in 1...100
        {
            let r = arc4random_uniform(100)
            if r<=80 {c++}
        }
        println("c: \(c)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func changeEvent(recognizer: UITapGestureRecognizer)
    {
        var oldSeq = self.sceneSeq
        println("changeevent \(oldSeq)")
        sceneSeq++
        if sceneSeq >= eventDetail?.scene.count
        {
            println("return")
            return
        }
        displayScene(oldSeq+1)
    }
    func nextScene(sender: UIButton)
    {
        println(sender.tag)
        displayScene(sender.tag-1)
    }
    func displayScene(sceneSeq: Int)
    {
        var scene = scenes[sceneSeq]
        backgroundImage.image = UIImage(named: scene.backgroundImage!)
        backText.text = scene.backText
        dialog.text = scene.dialog
        println(scene.button)
        self.sceneSeq = sceneSeq

        if scene.button != nil
        {
            var allEventButtons:[EventButton] = scene.button!
            var count = 0
            for eventButton in allEventButtons
            {
                var button = UIButton()
                button.setTitle(eventButton.title, forState: .Normal)
                button.tag = eventButton.nextSequence
                button.frame = eventButton.position
                button.setBackgroundImage(UIImage(named: "btn1_1.png"), forState: .Normal)
                button.addTarget(self, action: "nextScene:", forControlEvents: .TouchUpInside)
                self.view.addSubview(button)
                count++
                
            }
            backgroundImage.removeGestureRecognizer(touch)
        }else{
            for view in self.view.subviews
            {
                if view.isKindOfClass(UIButton)
                {
                    view.removeFromSuperview()
                }
            }
            backgroundImage.addGestureRecognizer(touch)
        }
        var c = 0
        for i in 1...100
        {
            let r = arc4random_uniform(100)
            if r<=80 {c++}
        }
        println("c: \(c)")
    }
    func prepareEvent()
    {
        var buttonDef = [["Go 3",3,50,360,40,20],["Go 5",5,110,360,40,20]]
        var buttons = [EventButton]()
        for i in 0..<2
        {
            var def = buttonDef[i]
            var button = EventButton(title: def[0] as String, nextSequence: def[1] as Int, position: CGRect(x: def[2] as Int, y: def[3] as Int, width: def[4] as Int, height: def[5] as Int))
            buttons.append(button)
        }
        var sceneDef = [["z-01.png","z-05","dialog 1 in z-02",[]],
                        ["z-02.png","z-05","dialog 2 in z-02",[["Go 3",3,50,360,40,20],["Go 5",5,110,360,40,20]]],
                        ["z-03.png","z-05","dialog 3 in z-02",[]],
                        ["z-04.png","z-05","dialog 4 in z-02",[]],
                        ["z-05.png","z-05","dialog 5 in z-02",[["Go 3",3,50,360,40,20],["Go 5",5,110,360,40,20]]]]
        for i in 0..<sceneDef.count
        {
            var def = sceneDef[i]
            //var buttons:[Array]? = def[3]
            /*if buttons!.count<=0
            {
                buttons = nil
            }*/
            var scene = Scene(backgroundImage: def[0] as String, backText: def[1] as String, dialog: def[2] as String, button: def[3] as? [EventButton])
            scenes.append(scene)

        }
        /*
        var button = EventButton(title: "Go 3",nextSequence: 3,position: CGRect(x: 50, y: 360, width: 40, height: 20))
        buttons.append(button)
        button = EventButton(title: "Go 5", nextSequence: 5,position: CGRect(x: 110, y: 360, width: 40, height: 20))
        buttons.append(button)
        */
        /*
        var scene = Scene(backgroundImage: "z-01.png", backText: "z-01", dialog: "dialog 1 in z-02", button: nil)
        scenes.append(scene)
        scene = Scene(backgroundImage: "z-02.png", backText: "z-02", dialog: "dialog 2 in z-02", button: buttons)
        scenes.append(scene)
        scene = Scene(backgroundImage: "z-03.png", backText: "z-03", dialog: "dialog 2 in z-02", button: nil)
        scenes.append(scene)
        scene = Scene(backgroundImage: "z-04.png", backText: "z-04", dialog: "dialog 2 in z-02", button: nil)
        scenes.append(scene)
        scene = Scene(backgroundImage: "z-05.png", backText: "z-05", dialog: "dialog 2 in z-02", button: buttons)
        scenes.append(scene)
*/
        println(scenes)
        eventDetail = EventDetail(sequence: 1, scene: scenes)
        
    }
    func showDefaultEventDetail(){
        var scene = eventDetail?.scene[0] as Scene!
        backgroundImage.image = UIImage(named: scene.backgroundImage!)
        backText.text = scene.backText
        
        
    }
    
    
    
    
    
    
}
