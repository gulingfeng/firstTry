//
//  Dropdown.swift
//  DropdownList
//
//  Created by gulingfeng on 14-9-21.
//  Copyright (c) 2014年 gulingfeng. All rights reserved.
//

import Foundation
import UIKit

//
//  UITableViewController.h
//  UIKit
//
//  Copyright (c) 2008-2014 Apple Inc. All rights reserved.
//

// Creates a table view with the correct dimensions and autoresizing, setting the datasource and delegate to self.
// In -viewWillAppear:, it reloads the table's data if it's empty. Otherwise, it deselects all rows (with or without animation) if clearsSelectionOnViewWillAppear is YES.
// In -viewDidAppear:, it flashes the table's scroll indicators.
// Implements -setEditing:animated: to toggle the editing state of the table.

class Dropdown : UIView, UITableViewDelegate, UITableViewDataSource {
    
    var basicFrame: CGRect
    var options:[String]
    var tv: UITableView
    var selectedOption: UIButton
    var showed = false
    var id = 0
    // MARK: - Table view data source
    override init(frame: CGRect) {
        basicFrame = frame
        options = []
        tv = UITableView()
        selectedOption = UIButton()

        super.init(frame: frame)
        
    }
    
    func initDropDown(x: Int, y: Int, width: Int, height: Int, options: [String],id:Int)
    {
        tv.delegate = self;
        tv.dataSource = self;
        tv.backgroundColor = UIColor.grayColor()
        tv.frame = CGRect(x: x, y: y+20, width: width, height: 400)
        tv.backgroundColor = UIColor.clearColor()
        tv.opaque = false
        self.addSubview(tv)
        tv.hidden = false
        selectedOption.frame = CGRect(x: x, y: y, width: width, height: 20)
        selectedOption.layer.borderWidth = 1;
        selectedOption.layer.borderColor = UIColor.blackColor().CGColor
        selectedOption.layer.cornerRadius = 5;
        selectedOption.addTarget(self, action: "dropdownlist:", forControlEvents: .TouchUpInside)
        self.addSubview(selectedOption)
        self.options = options
        var max = width
        for temp in options
        {
            
        }
        self.id = id
        tv.frame = CGRect(x: x, y: y+height, width: width, height: height*(options.count))
        selectedOption.frame = CGRect(x: x, y: y, width: width, height: height)
    }

    func dropdownlist(sender: UIButton)
    {
        println("show")
        if showed
        {
            showed = false
            tv.hidden = true
        }else{
            showed = true
            tv.hidden = false
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.options.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cellId: String = "CellIdentifier\(self.id)"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? UITableViewCell

        if cell != nil
        {
            cell!.textLabel?.text = self.options[indexPath.row]
        }else{
            cell = UITableViewCell(style: .Value1, reuseIdentifier: cellId)
            cell?.accessoryType = .None
            cell?.editingAccessoryType = .None
            
            cell!.textLabel?.text = self.options[indexPath.row]
        }
    
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        	return selectedOption.frame.height
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        selectedOption.setTitle(cell?.textLabel?.text, forState: .Normal)
        selectedOption.setTitleColor(UIColor.blackColor(), forState: .Normal)
        tv.hidden = true
        showed = false
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    
    // Override to support editing the table view.
    /*
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            // Delete the row from the data source
            self.options.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
    }
    */
}
