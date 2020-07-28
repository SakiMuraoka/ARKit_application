//
//  ButtonGameView.swift
//  ARkit_sample
//
//  Created by 村岡沙紀 on 2020/07/19.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import UIKit

class ButtonGameView: UIViewController {
    
    var NavigationTitle = ""
    @IBOutlet weak var ButtonGameNavigation: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ButtonGameNavigation.title = NavigationTitle
    }
}
