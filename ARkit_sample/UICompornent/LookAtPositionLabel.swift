//
//  LookAtPositionLabel.swift
//  ARkit_sample
//
//  Created by 村岡沙紀 on 2020/07/18.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//視線位置数値表示

import UIKit
import SceneKit

extension GazeLocation {
    func drawLookAtPointLabel() {
        self.lookAtPointLabel.frame = CGRect(x: 0, y: self.windowHeight-30, width: self.windowWidth, height: 15)
        self.lookAtPointLabel.textColor = UIColor.black
        self.lookAtPointLabel.font = UIFont.systemFont(ofSize: 12)
        self.lookAtPointLabel.textAlignment = NSTextAlignment.center
        self.view.addSubview(self.lookAtPointLabel)
    }

    func updateLookAtPointText(lookAt: simd_float3) {
        self.lookAtPointLabel.text = "x: \(String(format: "%.5f", lookAt[0])), y: \(String(format: "%.5f", lookAt[1])), z: \(String(format: "%.5f", lookAt[2]))"
    }
}

