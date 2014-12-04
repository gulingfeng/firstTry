//
//  MyItemView.swift
//  DBBuilder
//
//  Created by gulingfeng on 14-12-1.
//  Copyright (c) 2014年 gulingfeng. All rights reserved.
//

import Cocoa
import Foundation

class MyItemView: NSView{
    
    var selected: Bool = false
    
    func setSelected(flag: Bool){
        
        if(flag == self.selected){
            return
        }
        self.selected = flag
        self.setNeedsDisplayInRect(self.bounds)
    }
    
    override func drawRect(dirtyRect: NSRect) {
        
        (self.subviews[0] as NSButton).transparent = !selected //设置箭头是否可见
        
        if(selected){
            NSColor.selectedControlColor().setFill()
            NSRectFill(self.bounds)
        }
    }
}
