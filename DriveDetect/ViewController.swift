//
//  ViewController.swift
//  DriveDetect
//
//  Created by Thulani Mtetwa on 2023/11/01.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var stationaryLabel: UILabel!
    @IBOutlet weak var walkingLabel: UILabel!
    @IBOutlet weak var runningLabel: UILabel!
    @IBOutlet weak var automotiveLabel: UILabel!
    @IBOutlet weak var cyclingLabel: UILabel!
    @IBOutlet weak var unknownLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var confidenceLabel: UILabel!
    @IBOutlet weak var actitvityLabel: UILabel!
    let motionActivityManager = CMMotionActivityManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        switch CMMotionActivityManager.authorizationStatus() {
        case .authorized:
            if CMMotionActivityManager.isActivityAvailable() {
                motionActivityManager.startActivityUpdates(to: OperationQueue.main) { (motion) in
                    self.stationaryLabel.text = (motion?.stationary)! ? "True" : "False"
                    self.walkingLabel.text = (motion?.walking)! ? "True" : "False"
                    self.runningLabel.text = (motion?.running)! ? "True" : "False"
                    self.automotiveLabel.text = (motion?.automotive)! ? "True" : "False"
                    self.cyclingLabel.text = (motion?.cycling)! ? "True" : "False"
                    self.unknownLabel.text = (motion?.unknown)! ? "True" : "False"
                    
                    self.startDateLabel.text = dateFormatter.string(from: (motion?.startDate)!)
                    
                    if motion?.confidence == CMMotionActivityConfidence.low {
                        self.confidenceLabel.text = "Low"
                    } else if motion?.confidence == CMMotionActivityConfidence.medium {
                        self.confidenceLabel.text = "Good"
                    } else if motion?.confidence == CMMotionActivityConfidence.high {
                        self.confidenceLabel.text = "High"
                    }
                }
                
                let calendar = Calendar.current
                motionActivityManager.queryActivityStarting(from: calendar.startOfDay(for: Date()),
                                                            to: Date(),
                                                            to: OperationQueue.main) { (motionActivities, error) in
                    for motionActivity in motionActivities! {
                        if motionActivity.walking {
                            self.actitvityLabel.text = motionActivity.description
                        }
                    }
                }
                
            }
        case .denied, .notDetermined, .restricted:
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: { setting in
                print(setting)
            })
        }
        
    }
    
}

