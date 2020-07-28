//
//  MainExperiment.swift
//  ARkit_sample
//
//  Created by 村岡沙紀 on 2020/07/12.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import UIKit

class Experiment : UIViewController {
    var NameString = ""
    var ExperimentTitle = ""
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var ExperimentNavigation: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NameLabel.text = NameString
        ExperimentNavigation.title = ExperimentTitle
    }
}
