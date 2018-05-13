//
//  selectChargeMoneyViewController.swift
//  coffee_management
//
//  Created by kota on 2018/04/29.
//  Copyright © 2018年 Masataka W. All rights reserved.
//

import UIKit

class selectChargeMoneyViewController: UIViewController{
    
    var delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let defaults = UserDefaults.standard
    var userRowNum:Int = 0
    var possessionMoney: [Int] = []
    
    @IBOutlet weak var TableView: UITableView!

//    let moneyChoice:[Int] = [5,10,50,100,200,300,400,500,1000]
    let moneyChoice:[Int] = [200,300,400,500,1000,5,10,50,100]
    var Money:Int64 = 0//要変更
    var drinkNum:Int64 = 0//要変更

    override func viewDidLoad() {
        super.viewDidLoad()
        userRowNum = self.delegate.user
        print("++++",userRowNum,"++++")
        TableView.contentOffset.y = aTableCellsHeight
        possessionMoney = defaults.array(forKey: "possessionMoney") as! [Int]
        
        //tableViewの罫線を表示させない
        self.TableView.separatorColor = UIColor.clear
        
    }
}

/*
 * UITableView datasource UITableViewDelegate ---------------
 */
extension selectChargeMoneyViewController: UITableViewDataSource, UITableViewDelegate {
    var aTableCellsHeight:CGFloat{
        get {return 2 * 9 * 200.0}
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // cellを選択できなくする
        tableView.allowsSelection = false
        return moneyChoice.count * 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let moneyCell: selectChargeMoneyTableViewCell!
        moneyCell = tableView.dequeueReusableCell(withIdentifier: "moneyCell", for: indexPath) as! selectChargeMoneyTableViewCell
        let fixedIndex = IndexPath(row: indexPath.row%moneyChoice.count, section: 0)
        moneyCell.tag = fixedIndex.row
        // セルに表示する値を設定する
        moneyCell.chargeMoneyButton.setTitle(String(moneyChoice[fixedIndex.row]), for: .normal)
        moneyCell.delegate = self
        tableView.rowHeight = 200
        return moneyCell
    }
}

/*
 * UIScrollView datasource ---------------
 */
extension selectChargeMoneyViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /**端に行った際に中央にセットしなおす*/
        if (scrollView.contentOffset.y<=0)||(scrollView.contentOffset.y>=aTableCellsHeight*2.0) {
            scrollView.contentOffset.y = aTableCellsHeight
        }
    }
}

/*
 * selectChargeMoneyViewController chargeMoneyDelegate ---------------
 */
// cell上のボタンを押した際に呼び出される
extension selectChargeMoneyViewController: chargeMoneyDelegate {
    func chargeMoneyChoise(tag: Int){
        self.delegate.price = Int64(moneyChoice[tag])
        print(self.delegate.price)
        //入金確認アラート表示
        let alert: UIAlertController = UIAlertController(title: "入金確認", message: "本当に入金してもよろしいですか？", preferredStyle:  UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            //入金金額をuserdefaultsに保存
            //            self.possessionMoney = self.defaults.array(forKey: "possessionMoney") as! [Int]
            self.possessionMoney[self.userRowNum-1] += Int(self.delegate.price)
            self.defaults.set(self.possessionMoney, forKey: "possessionMoney")
            print("OK")
            //home画面に戻る
            self.navigationController?.popViewController(animated: true)
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
        })
        // UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // Alertを表示
        present(alert, animated: true, completion: nil)
        
        print(possessionMoney[userRowNum-1])
        defaults.set(false, forKey: "secondLaunch")
    }
    
}
