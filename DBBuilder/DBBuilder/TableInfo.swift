//
//  TableInfo.swift
//  DBBuilder
//
//  Created by gulingfeng on 14-11-24.
//  Copyright (c) 2014年 gulingfeng. All rights reserved.
//

import Foundation

class TableInfo: NSObject{
    //列数
    class var numberOfColumn: Int{
        return 11
    }
    
    //列宽
    class var widthOfColumn: Int{
    return 135
    }
    
    //列高
    class var heightOfColumn: Int{
    return 20
    }
    
    var column0 = String()
    var column1 = String()
    var column2 = String()
    var column3 = String()
    var column4 = String()
    var column5 = String()
    var column6 = String()
    var column7 = String()
    var column8 = String()
    var column9 = String()
    var column10 = String()
    
    override init(){
        column0 = ""
        column1 = ""
        column2 = ""
        column3 = ""
        column4 = ""
        column5 = ""
        column6 = ""
        column7 = ""
        column8 = ""
        column9 = ""
        column10 = ""
    }
    
    //设置列
    func setColumn(columnIndex: Int32, columnValue: String){
        switch columnIndex {
        case 0:
            column0 = columnValue
        case 1:
            column1 = columnValue
        case 2:
            column2 = columnValue
        case 3:
            column3 = columnValue
        case 4:
            column4 = columnValue
        case 5:
            column5 = columnValue
        case 6:
            column6 = columnValue
        case 7:
            column7 = columnValue
        case 8:
            column8 = columnValue
        case 9:
            column9 = columnValue
        default:
            column10 = columnValue
        }
    }
}