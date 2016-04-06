//
//  HistoryTableViewController.swift
//  StepCounter
//
//  Created by Guo Xiaoyu on 4/5/16.
//  Copyright © 2016 Xiaoyu Guo. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {

    let cellIdentifier = "historyTVCell"
    var stepsAndDatesDict = [NSDate: Double]()
    var stepsAndDatesArray = [(NSDate, Double)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        get29DaysNumOfSteps()
    }
    
    func get29DaysNumOfSteps() {
        HealthKitHelper().get29DaysNumOfSteps(updateTbleView)
    }
    
    func updateTbleView(dates: [NSDate], steps: [Double]) {
        for i in 0 ..< 29 {
            stepsAndDatesDict[dates[i]] = steps[i]
        }
        stepsAndDatesArray = stepsAndDatesDict.sort(isOrderedBefore)
        tableView.reloadData()
    }
    
    func isOrderedBefore(pair1 : (NSDate, Double), pair2 : (NSDate, Double)) -> Bool {
        if pair1.0.compare(pair2.0) == .OrderedDescending {
            return true
        }
        else {
            return false
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Steps In The Past 29 Days"
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stepsAndDatesDict.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = String(stepsAndDatesArray[indexPath.row].1)
        let index = String("11111111111111").startIndex.advancedBy(10)
        cell.detailTextLabel?.text = String(stepsAndDatesArray[indexPath.row].0).substringToIndex(index)

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
