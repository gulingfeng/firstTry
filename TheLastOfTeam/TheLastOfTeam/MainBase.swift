//
//  MainBase.swift
//  TheLastOfTean
//
//  Created by gulingfeng on 14-10-2.
//  Copyright (c) 2014年 gulingfeng. All rights reserved.
//

import Foundation

class MainBase
{
    //食物: 120  物资: 82  防御: 48  安全: 95  卫生: 89  幸存者: 7
    var food = 0
    var supply = 0
    var defend = 0
    var security = 0
    var health = 0
    var character = [Character]()
    var touchRecord =  [Int:SceneDetail]()

    var objs = [MainBaseObj]()
    
    class var shared:MainBase {
        return Inner.instance
    }
    
    struct Inner {
        static var instance = MainBase()
    }
    
}

class ObjectType
{
    var typeID:Int
    var desc:String
    
    init(typeID:Int,desc:String)
    {
        self.typeID = typeID
        self.desc = desc
    }
}
class MainBaseObj
{
    var objType: ObjectType
    var objID: Int
    var value: Int
    
    init(objType:ObjectType,objID:Int,value:Int)
    {
        self.objID = objID
        self.objType = objType
        self.value = value
    }
}
class Character
{
    var id: Int
    var name: String
    var health: Int
    var loyalty: Int
    var power: Int
    var image: String
    
    init(id:Int, name:String, health: Int, loyalty: Int, power: Int, image: String)
    {
        self.id = id
        self.name = name
        self.health = health
        self.loyalty = loyalty
        self.power = power
        self.image = image
    }
}