//
//  GazeLocation.swift
//  ARkit_sample
//
//  Created by 村岡沙紀 on 2020/07/15.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import UIKit
import ARKit

class GazeLocation : UIViewController, UIGestureRecognizerDelegate{
    
    var NavigationTitle = ""
    
    var trackingMode: String?
    let session = ARSession()
    var leftEyeBlinkView: EyeBlinkView!
    var rightEyeBlinkView: EyeBlinkView!
    var Looking: LookAtPosition!
    let lookAtPointLabel = UILabel()
    var faceDirectionArrow: FaceDirectionArrowView!
    
    let diameter: CGFloat = 75
    var windowWidthCenter: CGFloat!
    let distanceFromCenter: CGFloat = 100
    
    var length: CGFloat = 30
    var windowWidth: CGFloat!
    var windowHeight: CGFloat!
    
    var faceNode = SCNNode()
    var cameraNode = SCNNode()
    
    var priorFaceAnchor: ARFaceAnchor!
    @IBOutlet weak var NavigationItem: UINavigationItem!
    
    @IBOutlet weak var ImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NavigationItem.title = NavigationTitle
        
        self.session.delegate = self
        
        self.setNeedsStatusBarAppearanceUpdate()
        
        self.windowWidth = self.view.frame.width
        self.windowHeight = self.view.frame.height
        self.windowWidthCenter = self.view.bounds.width / 2
        
        firstRender()
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.tapped(_:)))
        
        // デリゲートをセット
        tapGesture.delegate = self
        
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer){
        if sender.state == .ended {
            let location = sender.location(in: self.view)
            print("タップ:" + location.x.description + "," + location.y.description)
            print("視線:" + Looking.posx.description + "," + Looking.posy.description)
        }
    }
    
       override func viewDidAppear(_ animated: Bool) {
             super.viewDidAppear(animated)
             resetTracking()
         }
     
         override func viewWillDisappear(_ animated: Bool) {
             super.viewWillDisappear(animated)
             session.pause()
         }
     
         override var prefersStatusBarHidden: Bool{
             return true
         }
}
extension GazeLocation: ARSessionDelegate{
        func resetTracking() {
            print("reset");
            guard ARFaceTrackingConfiguration.isSupported else { return }
            //ARSessionの設定
            let configration = ARFaceTrackingConfiguration()
            //撮影した画像におけるシーン照明を解析するかどうかの指定
            configration.isLightEstimationEnabled = true
            //座標軸の設定(y軸が重力と並行，上が正．原点はconfig更新時のデバイスの中心．)
            configration.worldAlignment = ARConfiguration.WorldAlignment.gravity
            self.session.run(configration, options: [.resetTracking, .removeExistingAnchors])
        }
        
        func session(_ session: ARSession, didUpdate frame: ARFrame) {
            frame.anchors.forEach { anchor in
                guard #available(iOS 12.0, *), let faceAnchor = anchor as? ARFaceAnchor else { return }
                if faceAnchor.isTracked {
                    //FaceAnchorから目の位置や向きが取得可能
                    let face = faceAnchor.transform           //顔の向き
                    let point = faceAnchor.lookAtPoint   //視線の方向
                    updateLookAtPointText(lookAt: point)
                    
                    let eyeBlinkLeft = faceAnchor.blendShapes[.eyeBlinkLeft]    //左目まばたき
                    //print("blinkLeft: \(String(describing: eyeBlinkLeft))")
                    let eyeBlinkRight = faceAnchor.blendShapes[.eyeBlinkRight]  //右目まばたき
                    //print("blinkRight: \(String(describing: eyeBlinkRight))")
                    blinkRender(leftBlink: eyeBlinkLeft, rightBlink: eyeBlinkRight)

                    //face cordinate spaceへの変換行列をfaceNodeに設定
                    self.faceNode.simdTransform = face
                    //camera cordinate spaceへの変換行列をcameraNodeに設定
                    let cameraTransform = frame.camera.transform
                    self.cameraNode.simdTransform = cameraTransform
                    
                    //world cordinationにおけるカメラの座標（絶対(0,0,0))を利用してスクリーン中心の座標取得
                    let cameraPosition = SCNVector3Make(
                            cameraTransform.columns.3.x,
                            cameraTransform.columns.3.y - 0.0718,
                            cameraTransform.columns.3.z)
                    //face cordinate spaceにおけるカメラの座標（のはず）
                    let cameraOnFaceNode = faceNode.convertPosition(cameraPosition, from: nil)
                    
                    self.faceDirectionArrow.setParams(x: CGFloat(cameraOnFaceNode.x), y: CGFloat(cameraOnFaceNode.y))
                    
                    if trackingMode == "gaze direction and face orientation" {
                        //face cordinate spaceにおけるスクリーンの法線ベクトルを求めるための座標
                        let cameraDirection = SCNVector3Make(
                                    cameraTransform.columns.3.x,
                                    cameraTransform.columns.3.y - 0.0718,
                                    cameraTransform.columns.3.z + 1)
                        let cameraDirectionOnFaceNode = faceNode.convertPosition(cameraDirection, from: nil)
                        
                        let leftEye = faceAnchor.leftEyeTransform
                        let rightEye = faceAnchor.rightEyeTransform
                        let eyesCenter = SCNVector3Make(
                                        (leftEye.columns.3.x + rightEye.columns.3.x)/2,
                                        (leftEye.columns.3.y + rightEye.columns.3.y)/2,
                                        (leftEye.columns.3.z + rightEye.columns.3.z)/2)
                        
                        //self.Looking.getIntersection(camera: cameraOnFaceNode, cameraDirection: cameraDirectionOnFaceNode, facePosition: SCNVector3Make(0, 0, 0), lookAt: point)
                        self.Looking.getIntersection(camera: cameraOnFaceNode, cameraDirection: cameraDirectionOnFaceNode, facePosition: eyesCenter, lookAt: point)
                    } else if trackingMode == "only gaze direction"{
                        self.Looking.cordinationConvertor(lookAt: point)
                    } else {
                        let intersection = [point[0] - cameraOnFaceNode.x,
                                            point[1] - cameraOnFaceNode.y,
                                            point[2] - cameraOnFaceNode.z]
                        self.Looking.convertMeterToPoint(intersection: intersection)
                    }
                } else {
                    self.leftEyeBlinkView.invisible()
                    self.rightEyeBlinkView.invisible()
                }
            }
        }
        
        func session(_ session: ARSession, didFailWithError error: Error) {}
}

extension GazeLocation {
    func firstRender() {
        //グリッド線の描画
        let gridView = GridView(frame: self.view.bounds)
        self.view.addSubview(gridView)
        
        //顔の方向を示す矢印の表示
        self.faceDirectionArrow = FaceDirectionArrowView(frame: self.view.bounds)
        self.view.addSubview(self.faceDirectionArrow)
        
        //左目まばたき表示
        self.leftEyeBlinkView = EyeBlinkView(frame: self.view.bounds)
        self.leftEyeBlinkView.setPosition(posx: windowWidthCenter + distanceFromCenter)
        self.view.addSubview(self.leftEyeBlinkView)
        
        //右目まばたき表示
        self.rightEyeBlinkView = EyeBlinkView(frame: self.view.bounds)
        self.rightEyeBlinkView.setPosition(posx: windowWidthCenter - distanceFromCenter)
        self.view.addSubview(self.rightEyeBlinkView)
        
        //注視点表示
        self.Looking = LookAtPosition(frame: self.view.bounds)
        self.view.addSubview(self.Looking)
        
        drawLookAtPointLabel()
    }
    
    func blinkRender(leftBlink: NSNumber?, rightBlink: NSNumber?) {
        //まばたきviewの更新
        if leftBlink != nil{
            let h: CGFloat = diameter * (1 - CGFloat(truncating: leftBlink!))
            self.leftEyeBlinkView.resetHeight(height: h)
        } else {
            self.leftEyeBlinkView.invisible()
        }
        if rightBlink != nil{
            let h: CGFloat = diameter * (1 - CGFloat(truncating: rightBlink!))
            self.rightEyeBlinkView.resetHeight(height: h)
        } else {
            self.rightEyeBlinkView.invisible()
        }
    }
    
}
