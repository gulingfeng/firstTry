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
    var character = 0
    
    class var shared:MainBase {
        return Inner.instance
    }
    
    struct Inner {
        static var instance = MainBase()
    }
    
}