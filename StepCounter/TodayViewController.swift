//
//  TodayViewController.swift
//  StepCounter
//
//  Created by Guo Xiaoyu on 4/5/16.
//  Copyright © 2016 Xiaoyu Guo. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {

    @IBOutlet weak var stepCounterLabel: UILabel!
    @IBOutlet weak var manWalkingImgView: FLAnimatedImageView!
    var timer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let manWalingGif = FLAnimatedImage.init(animatedGIFData: NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("walking", ofType: "gif")!))
        manWalkingImgView.animatedImage = manWalingGif
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // add observer
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(updateNumOfSteps), userInfo: nil, repeats: true)
    }
    
    func updateNumOfSteps() {
        HealthKitHelper().getTodayNumOfSteps(updateUI)
    }
    
    func updateUI(numOfSteps : Double, error : NSError?) {
        if error == nil {
            dispatch_async(dispatch_get_main_queue()) {
                self.stepCounterLabel.text = "\(numOfSteps)"
            }
        }
        else {
            showErrorAlertView(error!)
        }
    }

    func showErrorAlertView(error : NSError) {
        let alert = UIAlertController(title: "Error", message: error.description, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
