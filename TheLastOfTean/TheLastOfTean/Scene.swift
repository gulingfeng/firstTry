//
//  Scene.swift
//  TheLastOfTean
//
//  Created by gulingfeng on 14-9-30.
//  Copyright (c) 2014年 gulingfeng. All rights reserved.
//

import Foundation

enum ActionType: String
{
    case add = "A"
    case delete = "D"
    case replace = "R"
}
class SceneDetail
{
    let sceneID: Int
    let resource: SceneResource
    let action: ActionType
    let nexSceneID: Int
    let rewardGroup: Int
    init(sceneID: Int, resource: SceneResource, action: ActionType, nextSceneID: Int, rewardGroup: Int)
    {
        self.sceneID = sceneID
        self.resource = resource
        self.action = action
        self.nexSceneID = nextSceneID
        self.rewardGroup = rewardGroup
    }
    
}

enum ResourceType: Int
{
    case image = 1;
    case label;
    case button;
}
class SceneResource
{
    let globalID:Int
    let type: ResourceType
    let positionX: Float
    let positionY: Float
    let width: Float
    let height: Float
    let alpha: Float
    let countTouch: Boolean
    var touchCount: Int
    let selfDelete: Int
    let content: String
    init(globalID:Int, type: ResourceType, content: String, positionX: Float, positionY: Float, width: Float, height: Float, alpha: Float, countTouch: Boolean, touchCount: Int, selfDelete: Int)
    {
        self.globalID = globalID
        self.type = type
        self.positionX = positionX
        self.positionY = positionY
        self.width = width
        self.height = height
        self.alpha = alpha
        self.countTouch = countTouch
        self.touchCount = touchCount
        self.selfDelete = selfDelete
        self.content = content
    }
}