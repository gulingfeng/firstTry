//
//  TableNameDataSource.swift
//  DBBuilder
//
//  Created by gulingfeng on 14-11-13.
//  Copyright (c) 2014年 gulingfeng. All rights reserved.
//

import Cocoa
import Foundation

class TableNameListTree:NSObject, NSOutlineViewDataSource{

    var treeNode: NSArray = NSArray()
    
    override init(){

        treeNode = NSArray(array: ["aaa","bbb","ccc"])
     println("init")
    }
    
 
    func outlineView(outlineView: NSOutlineView!, child index: Int, ofItem item: AnyObject!) -> AnyObject!{
        println("ok")
        return (item == nil) ? treeNode.objectAtIndex(index) : nil
    }
    
    func outlineView(outlineView: NSOutlineView!, isItemExpandable item: AnyObject!) -> Bool{
        if(item == nil){
            return true
        }else{
            return false
        }
    }

    func outlineView(outlineView: NSOutlineView!, numberOfChildrenOfItem item: AnyObject!) -> Int{
        println(treeNode.count)
        return (item == nil) ? treeNode.count : 0
    }
    
    func outlineView(outlineView: NSOutlineView!, objectValueForTableColumn tableColumn: NSTableColumn!, byItem item: AnyObject!) -> AnyObject!{
        return item
    }

}