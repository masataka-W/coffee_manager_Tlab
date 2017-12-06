//
//  ViewControllerRoulette.swift
//  coffee_management
//
//  Created by Masataka W. on 2017/11/28.
//  Copyright © 2017年 Masataka W. All rights reserved.
//

import UIKit

class selectDrink: UIViewController {
    var delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let defaults = UserDefaults.standard
    var drinkSelectButton: [UIButton] = []//black,black with milk,latte,...を選択するボタン
    let drinkSelection: NSArray = ["Black","Black with milk","Latte"]
    let drinkPrice:[Int64] = [20,25,40]//飲み物の金額
    var InitMoney: [String] = []
    var InitDrinkNum: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        InitMoney = defaults.array(forKey: "DataMoney") as! [String]
        InitDrinkNum = defaults.array(forKey: "DataDrinkNum") as! [String]
        
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
            drink.addTarget(self, action: #selector(selectDrink.drinkCoffee(sender:)), for: .touchUpInside)
            
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
        let Money:Int64 = Int64(InitMoney[self.delegate.user])! - drinkPrice[sender.tag]
        InitMoney[self.delegate.user] = Money.description
        
        if InitDrinkNum[self.delegate.user] != "0" {
            let Lucky:Int64 = Int64(InitDrinkNum[self.delegate.user])! - 1
            InitDrinkNum[self.delegate.user] = Lucky.description
            defaults.set(InitDrinkNum, forKey: "DataDrinkNum")
            
            let Money:Int64 = Int64(InitMoney[self.delegate.user])! + drinkPrice[sender.tag]
            InitMoney[self.delegate.user] = Money.description
        }
        
        defaults.set(InitMoney, forKey: "DataMoney")

        let goRoulette = storyboard!.instantiateViewController(withIdentifier: "roulette")
        self.present(goRoulette,animated: true, completion: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
