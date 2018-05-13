//
//  ViewControllerRoulette.swift
//  coffee_management
//
//  Created by Masataka W. on 2017/11/28.
//  Copyright © 2017年 Masataka W. All rights reserved.
//

import UIKit

class selectDrinkViewController: UIViewController {
    
    var delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let defaults = UserDefaults.standard
    
    var drinkSelectButton: [UIButton] = []//black,black with milk,latte,...を選択するボタン
    let drinkSelection: NSArray = ["Black","with milk","Latte","Ice"]
    let drinkPrice:[Int64] = [20,25,40,20]//飲み物の金額
    let drinkButtonImage = ["hot","milk","lat","ice","cup"]
    var InitMoney: [Int] = []
    var InitDrinkNum: [Int] = []
    var index:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("----",self.delegate.user,"----")
        index = self.delegate.user - 1
        
        InitMoney = defaults.array(forKey: "possessionMoney") as! [Int]
        InitDrinkNum = defaults.array(forKey: "freeDrinkNumber") as! [Int]
        
        //ボタンの詳細設定のメソッドの呼び出し
        makeDrinkButtom()
        // 配列から取り出してViewに追加
        for drink in drinkSelectButton {
            view.addSubview(drink)
        }
       
    }
    
    @objc func drinkCoffee(sender: UIButton) {
        if(InitMoney[index] >= drinkPrice[sender.tag]){
            //飲んだコーヒーの種類に応じて合計入金額の値を変更するための料金の値を渡す
            let Money:Int64 = Int64(InitMoney[index]) - drinkPrice[sender.tag]
            InitMoney[index] = Int(Money)
            
            if InitDrinkNum[index] != 0 {
                let Lucky:Int64 = Int64(InitDrinkNum[index]) - 1
                InitDrinkNum[index] = Int(Lucky)
                defaults.set(InitDrinkNum, forKey: "freeDrinkNumber")
                
                let Money:Int64 = Int64(InitMoney[index]) + drinkPrice[sender.tag]
                InitMoney[index] = Int(Money)
            }
            defaults.set(InitMoney, forKey: "possessionMoney")
            self.performSegue(withIdentifier: "toRoulette", sender: nil)
        }else{
            dispAlert()
        }
    }
    
}

/*
 * ボタンの詳細設定 ---------------
 */
extension selectDrinkViewController {
    func makeDrinkButtom(){
        for i in 0..<drinkSelection.count {
        // Buttonを作成
        // UIButtonのインスタンスを作成する
        let drink = UIButton(type: .custom)
        drink.tag = i
        drinkSelectButton.append(drink)
        // イベントを追加する
        // ボタンを押した時に実行するメソッドを指定
        drink.addTarget(self, action: #selector(selectDrinkViewController.drinkCoffee(sender:)), for: .touchUpInside)
        // サイズを変更する
        drink.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        // 任意の場所に設置する
        drink.layer.position = CGPoint(x: self.view.frame.width/2, y:200 + 225 * CGFloat(i))
        // 背景色を変える
        drink.backgroundColor = UIColor(red: 0.3, green: 0.7, blue: 0.6, alpha: 1)
        // 枠の太さを変える
        drink.layer.borderWidth = 1.0
        // 枠の色を変える
        drink.layer.borderColor = UIColor(red: 0.3, green: 0.6, blue: 0.5, alpha: 1).cgColor
        // 枠に丸みをつける
        drink.layer.cornerRadius = 25
        // 影の濃さを決める
        drink.layer.shadowOpacity = 0.5
        // 影のサイズを決める
        drink.layer.shadowOffset = CGSize(width: 2, height: 2)
        // ラベルの色を指定
        drink.setTitleColor(UIColor.white, for: .normal)
        // ボタンが押された時のラベルの色を変更
        drink.setTitleColor(UIColor.black, for: .highlighted)
        // ラベルを設定する
        drink.setTitle(drinkSelection[i] as? String, for: .normal)
        // ボタンに画像を貼る
        drink.setImage(UIImage.init(named: drinkButtonImage[i]), for: .normal)
        // ボタンが押されたときの画像を変更する
        drink.setImage(UIImage.init(named: drinkButtonImage.last!), for: .highlighted)
        // ボタンないのテキストと画像の配置設定
        drink.titleEdgeInsets = UIEdgeInsetsMake(105.0, -130.0, 0, 0)
        drink.imageEdgeInsets = UIEdgeInsetsMake(-50.0, 10.0, 0, 0)
        }
    }
}

/*
 * 所持金が足りなかった時のアラートの設定 ---------------
 */
extension selectDrinkViewController {
    func dispAlert(){
        // ① UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        let alert: UIAlertController = UIAlertController(title: "所持金額が足りません", message: "入金しますか？", preferredStyle:  UIAlertControllerStyle.alert)
        
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "入金する", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            self.performSegue(withIdentifier: "toCharge", sender: nil)
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "違うモノを飲む", style: UIAlertActionStyle.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
        })
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
    }
}
