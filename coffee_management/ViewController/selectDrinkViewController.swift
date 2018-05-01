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
    let drinkSelection: NSArray = ["Black","Black with milk","Latte"]
    let drinkPrice:[Int64] = [20,25,40]//飲み物の金額
    var InitMoney: [Int] = []
    var InitDrinkNum: [Int] = []
    var index:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("----",self.delegate.user,"----")
        index = self.delegate.user - 1
        
        InitMoney = defaults.array(forKey: "possessionMoney") as! [Int]
        InitDrinkNum = defaults.array(forKey: "freeDrinkNumber") as! [Int]
        
        for i in 0..<drinkSelection.count {
            // Buttonを作成
            let drink = UIButton(type: .custom)
            drink.frame = CGRect(x:100 + 200 * CGFloat(i),y: 450,width: 150,height: 50)
            drink.setTitleColor(UIColor.white, for: .normal)
            drink.setTitle("\(drinkSelection[i])", for: .normal)
            drink.backgroundColor = UIColor.blue
            drink.tag = i
            drinkSelectButton.append(drink)
            // イベントを追加する
            drink.addTarget(self, action: #selector(selectDrinkViewController.drinkCoffee(sender:)), for: .touchUpInside)
            
        }
        // 配列から取り出してViewに追加
        for drink in drinkSelectButton {
            view.addSubview(drink)
            //print("drink is \(drink)")
        }
       
    }
    @objc func drinkCoffee(sender: UIButton) {
        
        //let goRoulette = storyboard!.instantiateViewController(withIdentifier: "roulette")
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

        let goRoulette = storyboard!.instantiateViewController(withIdentifier: "roulette")
        self.present(goRoulette,animated: true, completion: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
