//
//  ExperimentData.swift
//  ARkit_sample
//
//  Created by 村岡沙紀 on 2020/07/12.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import UIKit
import ARKit

class ExperimentData: UIViewController{
    
    @IBOutlet weak var NameText: UITextField!
    @IBOutlet weak var SegmentState: UISegmentedControl!
    var NavigationTitle = ""
    @IBOutlet weak var ExperimentDataNavigation: UINavigationItem!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowExperiment" {
            let nextView = segue.destination as! Experiment
            nextView.NameString = NameText.text!
            nextView.ExperimentTitle = SegmentState.titleForSegment(at: SegmentState.selectedSegmentIndex)!
        }
    }

    @IBAction func StartButton() {
        performSegue(withIdentifier: "ShowExperiment", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ExperimentDataNavigation.title = NavigationTitle
    }
    
}

