//
//  ViewController.swift
//  ARkit_sample
//
//  Created by 村岡沙紀 on 2020/07/11.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import UIKit
import ARKit

class MainMenuView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let mainMenuNavigationTitle = "メインメニュー"
    let tableMenu = ["取得数値データ", "実験データ", "取得視線位置", "ボタンゲーム", "ユーザ登録"]

        
    @IBOutlet weak var MainMenuNavigation: UINavigationItem!
    @IBOutlet weak var MenuTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        MenuTableView.delegate = self
        MainMenuNavigation.title = mainMenuNavigationTitle
        //MenuTableView.sectionHeaderHeight = 43.5 * CGFloat(tableMenu.count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableMenu.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // セルに表示する値を設定する
        cell.textLabel!.text = tableMenu[indexPath.row]
        return cell
    }
    var indexpath: IndexPath!
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 別の画面に遷移
        indexpath = indexPath
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "ShowNumetricData", sender: nil)
        case 1:
            performSegue(withIdentifier: "ShowExperimentData", sender: nil)
        case 2:
            performSegue(withIdentifier: "ShowGazeLocation", sender: nil)
        case 3:
            performSegue(withIdentifier: "ShowButtonGameView", sender: nil)
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ShowNumetricData":
            let nextView = segue.destination as! NumetricData
            nextView.NavigationTitle = MenuTableView.cellForRow(at: indexpath)!.textLabel!.text!
        case "ShowExperimentData":
            let nextView = segue.destination as! ExperimentData
            nextView.NavigationTitle = MenuTableView.cellForRow(at: indexpath)!.textLabel!.text!
        case "ShowGazeLocation":
            let nextView = segue.destination as! GazeLocation
            nextView.NavigationTitle = MenuTableView.cellForRow(at: indexpath)!.textLabel!.text!
        case "ShowButtonGameView":
            let nextView = segue.destination as! ButtonGameView
            nextView.NavigationTitle = MenuTableView.cellForRow(at: indexpath)!.textLabel!.text!
        default:
            break
        }
    }
}


