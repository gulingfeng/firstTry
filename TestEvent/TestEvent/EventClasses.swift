//
//  EventClasses.swift
//  TestEvent
//
//  Created by gulingfeng on 14-9-23.
//  Copyright (c) 2014年 gulingfeng. All rights reserved.
//

import Foundation
import UIKit

class EventDetail
{
    var sequence: Int
    var scene: [Scene]
    init(sequence: Int, scene: [Scene])
    {
        self.sequence = sequence
        self.scene = scene
    }
}

class Scene
{
    var backgroundImage: String?
    var backText: String?
    var dialog: String?
    var button: [EventButton]?
    init(backgroundImage: String,backText: String, dialog: String, button: [EventButton]?)
    {
        self.backgroundImage = backgroundImage
        self.backText = backText
        self.dialog = dialog
        self.button = button
    }
}

class EventButton
{
    var title: String
    var nextSequence: Int
    var position: CGRect
    init(title: String,nextSequence: Int, position: CGRect)
    {
        self.title = title
        self.nextSequence = nextSequence
        self.position = position
    }
    
}