//
//  NumericData.swift
//  ARkit_sample
//
//  Created by 村岡沙紀 on 2020/07/11.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import UIKit
import ARKit

class NumetricData : UIViewController, ARSessionDelegate {
    var FaceAngleData:simd_float4x4!
    var RightData:simd_float4x4!
    var LeftData :simd_float4x4!


    @IBOutlet var face_data0: [UILabel]!
    @IBOutlet var face_data1: [UILabel]!
    @IBOutlet var face_data2: [UILabel]!
    @IBOutlet var face_data3: [UILabel]!
    @IBOutlet var right_data0: [UILabel]!
    @IBOutlet var right_data1: [UILabel]!
    @IBOutlet var right_data2: [UILabel]!
    @IBOutlet var right_data3: [UILabel]!
    @IBOutlet var left_data0: [UILabel]!
    @IBOutlet var left_data1: [UILabel]!
    @IBOutlet var left_data2: [UILabel]!
    @IBOutlet var left_data3: [UILabel]!
    
    func label_print() {
        let face_data = [face_data0!, face_data1!, face_data2!, face_data3!]
        let right_data = [right_data0!, right_data1!, right_data2!, right_data3!]
        let left_data = [left_data0!, left_data1!, left_data2!, left_data3!]
        let data_matrix = [face_data, right_data, left_data]
        var i = 0, j = 0, k = 0
        var part: simd_float4x4!, part_row: simd_float4!
        for data_column in data_matrix {
            switch i {
            case 0:
                part = FaceAngleData
            case 1:
                part = RightData
            case 2:
                part = LeftData
            default:
                i = 0
                break
            }
            for data_line in data_column {
                switch j {
                case 0:
                    part_row = part.columns.0
                case 1:
                    part_row = part.columns.1
                case 2:
                    part_row = part.columns.2
                case 3:
                    part_row = part.columns.3
                default:
                    j = 0
                    break
                }
                for data in data_line {
                    switch k {
                    case 0:
                        data.text = String(describing: round(part_row.w*10000)/10000)
                        print(i.description + "," + j.description + "," + k.description + "," + String(describing: part_row.w))
                    case 1:
                        data.text = String(describing: round(part_row.x*10000)/10000)
                        print(i.description + "," + j.description + "," + k.description + "," + String(describing: part_row.x))
                    case 2:
                        data.text = String(describing: round(part_row.y*10000)/10000)
                        print(i.description + "," + j.description + "," + k.description + "," + String(describing: part_row.y))
                    case 3:
                        data.text = String(describing: round(part_row.z*10000)/10000)
                        print(i.description + "," + j.description + "," + k.description + "," + String(describing: part_row.z))
                    default:
                        break
                    }
                    k += 1
                }
                k = 0
                j += 1
            }
            j = 0
            i += 1
        }
    }
    
    var NavigationTitle = ""
    @IBOutlet weak var NumetricNavigation: UINavigationItem!
    //ARSession
    let session = ARSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.session.delegate = self
        NumetricNavigation.title = NavigationTitle
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //"Reset" to run the AR session for the first time
        resetTracking()
    }
    
    func resetTracking() {
        guard ARFaceTrackingConfiguration.isSupported else { return }
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        self.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        frame.anchors.forEach { anchor in
            guard #available(iOS 12.0, *), let faceAnchor = anchor as? ARFaceAnchor else { return }
            FaceAngleData = faceAnchor.transform
            //FaceAnchorから左，右目の位置や向きが取得可能
            LeftData = faceAnchor.leftEyeTransform
//            print("left:\(String(describing: LeftData))")
            RightData = faceAnchor.rightEyeTransform
//            print("right:\(String(describing: RightData))")
            label_print()
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {}
    
}


