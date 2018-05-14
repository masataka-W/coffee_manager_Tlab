//
//  ViewController.swift
//  coffee_management
//
//  Created by Masataka W. on 2017/11/22.
//  Copyright © 2017年 Masataka W. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    let dict2 = ["secondLaunch": true]//１回目の立ち上げでmoneyなどの値が更新されなかった時の対策
    var delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //利用者名
    var name: Array = ["河村", "福地", "峯口", "綿島", "榎田", "倉重", "川端","山田","末永","田中","仲地","長村","深町","矢野"]
    //投入金額
    var possessionMoney: [Int] = []
    //lcuky数
    var freeDrinkNumber: [Int] = []
    
    var contentOffset: CGPoint! //cellの位置座標取得
    var mChoice:Int64 = 0
    var userRowNum = 0//userChoiceの何列目のuserを指定しているか
    
    var dialLayout:AWCollectionViewDialLayout!
    var cell_height:CGFloat!
    var aTableCellsHeight:CGFloat{
        get {return 2 * 3 * 100 + 100}
    }
    
    @IBOutlet weak var DrinkButton: UIButton!
    @IBOutlet weak var ChargeButton: UIButton!
    @IBOutlet weak var DataButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DrinkButton.isEnabled = false
        
        //ボタンを丸くする
        DrinkButton.layer.cornerRadius = 125
        ChargeButton.layer.cornerRadius = 125
        DataButton.layer.cornerRadius = 125
        
        //AWCollectionViewの設定
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        collectionView.contentOffset.y = aTableCellsHeight
        let radius = CGFloat(0.39 * 1000)
        let angularSpacing = CGFloat(0.16 * 90)
        let xOffset = CGFloat(0.23 * 320)
        let cell_width = CGFloat(240)
        cell_height = 50
        dialLayout = AWCollectionViewDialLayout(raduis: radius, angularSpacing: angularSpacing, cellSize: CGSize(width: cell_width, height: cell_height) , alignment: WheelAlignmentType.center, itemHeight: cell_height, xOffset: xOffset)
        dialLayout.shouldSnap = true
        dialLayout.shouldFlip = true
        collectionView.collectionViewLayout = dialLayout
        dialLayout.scrollDirection = .horizontal
        self.switchExample()
        
        defaults.register(defaults: dict2)//１回目の立ち上げでmoneyなどの値が更新されなかった時の対策
        if defaults.bool(forKey: "firstLanch") {
            possessionMoney = [Int](repeating: 0, count: 14)
            freeDrinkNumber = [Int](repeating: 0, count: 14)
            defaults.set(possessionMoney, forKey: "possessionMoney")
            defaults.set(freeDrinkNumber, forKey: "freeDrinkNumber")
            defaults.set(false, forKey: "firstLanch")
        } else{
            if defaults.bool(forKey: "secondLaunch"){
                possessionMoney = [Int](repeating: 0, count: 14)
                freeDrinkNumber = [Int](repeating: 0, count: 14)
                possessionMoney = defaults.array(forKey: "possessionMoney") as! [Int]
                freeDrinkNumber = defaults.array(forKey: "freeDrinkNumber") as! [Int]
            } else {
                possessionMoney = defaults.array(forKey: "possessionMoney") as! [Int]
                freeDrinkNumber = defaults.array(forKey: "freeDrinkNumber") as! [Int]
            }
        }
        self.delegate.users = name
    }
    override func viewWillAppear(_ animated: Bool) {
        possessionMoney = defaults.array(forKey: "possessionMoney") as! [Int]
        freeDrinkNumber = defaults.array(forKey: "freeDrinkNumber") as! [Int]
        self.collectionView.reloadData()
        print("データの更新")
        print(possessionMoney[userRowNum-1])
    }
}

/*
 * ButtonActions ---------------
 */
extension ViewController {
    @IBAction func DrinkButton(_ sender: UIButton) {
        self.delegate.user = userRowNum
        
        // 遷移するViewを定義する.
    }
    
    @IBAction func ChargeButton(_ sender: UIButton) {
        self.delegate.user = userRowNum
        print("きちんと表示されてるよーー")
    }
}

/*
 * Actions ---------------
 */
extension ViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /**端に行った際に中央にセットしなおす*/
        if (scrollView.contentOffset.y<=0)||(scrollView.contentOffset.y>=aTableCellsHeight*2.0) {
            scrollView.contentOffset.y = aTableCellsHeight
        }
        //ユーザーのindexを取得
        contentOffset = scrollView.contentOffset
        userRowNum = Int(contentOffset.y-700)/50 + 1
        if (userRowNum<=0){
            userRowNum = userRowNum + 14
        }
        print(userRowNum)
        
//        if defaults.bool(forKey: "secondLaunch") {
        drinkDiscrimination()
//        }
    }
    
    //CollectionViewのレイアウトの設定
    func switchExample(){
        var radius:CGFloat = 0 ,angularSpacing:CGFloat  = 0, xOffset:CGFloat = 0
        dialLayout.cellSize = CGSize(width: 340, height: 100)
        dialLayout.wheelType = .left
        dialLayout.shouldFlip = false
        radius = 300
        angularSpacing = 28
        xOffset = 80
        dialLayout.dialRadius = radius
        dialLayout.angularSpacing = angularSpacing
        dialLayout.xOffset = xOffset
        collectionView.reloadData();
    }
    
    // 入金額20円以上かLuckynumberが1以上ならドリンクボタンを押せるようになる
    func drinkDiscrimination(){
        possessionMoney = defaults.array(forKey: "possessionMoney") as! [Int]
        freeDrinkNumber = defaults.array(forKey: "freeDrinkNumber") as! [Int]
        if (possessionMoney[userRowNum-1] >= 20 || freeDrinkNumber[userRowNum-1] > 0) {
            DrinkButton.isEnabled = true
        } else{
            DrinkButton.isEnabled = false
        }
    }
    
}

/*
 *  CollectionView delegate ---------------
 */
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.name.count * 3
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: mainViewControllerCell!
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! mainViewControllerCell
        let fixedIndex = IndexPath(row: indexPath.row%name.count, section: 0)
        cell.nameLable.text = name[fixedIndex.row]
        cell.moneyLabel.text = possessionMoney[fixedIndex.row].description
        cell.luckyLabel.text = freeDrinkNumber[fixedIndex.row].description
        return cell
    }
}



