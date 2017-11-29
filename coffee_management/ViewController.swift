//
//  ViewController.swift
//  coffee_management
//
//  Created by Masataka W. on 2017/11/22.
//  Copyright © 2017年 Masataka W. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let defaults = UserDefaults.standard
    var delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var addBtn: UIBarButtonItem!
    var userName: [UILabel] = []//利用者名
    var totalMoney: [UILabel] = []//投入金額
    var drinkLeft: [UILabel] = []//残飲数
    var drinkBlack: [UIButton] = []//drink_black_coffee
    @IBOutlet weak var selectAddMoney: UIPickerView!//入金
    @IBOutlet weak var selectModifyMoney: UIPickerView!//修正
    //@IBAction func goBack(_ segue:UIStoryboardSegue) {}
    
    let userChoice: NSArray = ["本城","河村","福地","綿島","榎田","川端","倉重","森","矢野","山田"]
    let moneyChoice: NSArray = ["0","20","50","100","200","300","400","500","1000"]
    var InitialDataMoney: [String] = ["0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"]
    var InitialDataDrinkNum: [String] = ["0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"]
    var uChoice:String = ""
    var mChoice:Int64 = 0
    var uChoiceM:String = ""//Modify用
    var mChoiceM:Int64 = 0//Modify用
    var index = 0
    var InitMoney: [String] = ["0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"]
    var InitDrinkNum: [String] = ["0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"]
    var Money:Int64 = 0//要変更
    var drinkNum:Int64 = 0//要変更
    var userRowNum = 0//userChoiceの何列目のuserを指定しているか
    var userRowNumM = 0//userChoiceの何列目のuserを指定しているかModify用
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if defaults.bool(forKey: "firstLanch") {
           defaults.register(defaults: ["InitialDataMoney":InitialDataMoney,"InitialDataDrinkNum":InitialDataDrinkNum])
           InitMoney = defaults.array(forKey: "InitialDataMoney") as! [String]
           InitDrinkNum = defaults.array(forKey: "InitialDataDrinkNum") as! [String]
           defaults.set(false, forKey: "firstLanch")
        } else {
           InitMoney = defaults.array(forKey: "DataMoney") as! [String]
           InitDrinkNum = defaults.array(forKey: "DataDrinkNum") as! [String]
        }
        
        selectAddMoney.dataSource = self
        selectAddMoney.delegate = self
        self.view.addSubview(selectAddMoney)
        
        selectModifyMoney.dataSource = self
        selectModifyMoney.delegate = self
        self.view.addSubview(selectModifyMoney)
        
        // ラベルの生成:userName
        for name in userChoice {
            // Labelを作成
            let user = UILabel()
            user.frame = CGRect(x:10,y: 60 * CGFloat(index) + 130,width: 80,height: 30)
            user.text = "\(name)"
            user.textAlignment = NSTextAlignment.center
            //user.backgroundColor = UIColor.blue
            user.tag = index
            userName.append(user)
            index += 1
        }
        
        // 配列から取り出してViewに追加
        for user in userName {
            view.addSubview(user)
        }
        // ラベルの生成:totalMoney
        for i in 0..<userChoice.count {
            // Labelを作成
            let total = UILabel()
            total.frame = CGRect(x:110,y: 60 * CGFloat(i) + 130,width: 80,height: 30)
            total.backgroundColor = UIColor.blue
            total.textColor = UIColor.white
            total.textAlignment = NSTextAlignment.right
            total.text = InitMoney[i]
//            total.text = defaults.array(InitialDataMoney[i],forKey: "DataDrinkNum") as! [String]
            total.tag = i
            totalMoney.append(total)
        }
        
        // 配列から取り出してViewに追加
        for total in totalMoney {
            view.addSubview(total)
        }
        
        // ラベルの生成:drinkLeft
        for j in 0..<userChoice.count {
            // Labelを作成
            let left = UILabel()
            left.frame = CGRect(x:210,y: 60 * CGFloat(j) + 130,width: 80,height: 30)
            left.backgroundColor = UIColor.blue
            left.textColor = UIColor.white
            left.textAlignment = NSTextAlignment.right
            left.text = InitDrinkNum[j]
            left.tag = j
            drinkLeft.append(left)
        }
        
        // 配列から取り出してViewに追加
        for left in drinkLeft {
            view.addSubview(left)
        }
        // ボタンの生成:drinkBlack
        for k in 0..<userChoice.count {
            // Labelを作成
            let black = UIButton(type: .custom)
            black.frame = CGRect(x:310,y: 60 * CGFloat(k) + 130,width: 50,height: 30)
            black.setTitleColor(UIColor.white, for: .normal)
            black.setTitle("drink", for: .normal)
            black.backgroundColor = UIColor.blue
            black.tag = k
            // イベントを追加する
            //black.addTarget(self, action: #selector(ViewController.drinkBlackCoffee(sender:)), for: .touchUpInside)
            black.addTarget(self, action: #selector(ViewController.selectDrink(sender:)), for: .touchUpInside)

            drinkBlack.append(black)

        }
        // 配列から取り出してViewに追加
        for black in drinkBlack {
            view.addSubview(black)
        }
        
    }
    
//    @objc func drinkBlackCoffee(sender: UIButton) {
//        Money = Int64(totalMoney[sender.tag].text!)! - self.delegate.price
//        if Money <= 0 {
//            Money = 0
//        }
//        drinkNum = Money/20
//        totalMoney[sender.tag].text = Money.description
//        drinkLeft[sender.tag].text = drinkNum.description
//    }
    @objc func selectDrink(sender: UIButton) {
        var money = Int64(InitMoney[sender.tag])
        self.delegate.user = sender.tag
        // 遷移するViewを定義する.
        if  money! >= 20 {
        let sDrink = storyboard!.instantiateViewController(withIdentifier: "selectDrink")
        self.present(sDrink,animated: true, completion: nil)
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (component == 0){
            return userChoice.count
        }else if (component == 1){
            return moneyChoice.count
        }
        return 0;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (component == 0){
            return userChoice[row] as? String
        }else if (component == 1){
            return moneyChoice[row] as? String
        }
        return "";
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == selectAddMoney{
            if (component == 0){
                print("列: \(row)")
                print("値: \(userChoice[row])")
                uChoice = userChoice[row] as! String//誰が
                userRowNum = row
            }else if (component == 1){
                print("列: \(row)")
                print("値: \(moneyChoice[row])")
                mChoice = (moneyChoice[row] as AnyObject).int64Value//何円
            }
        }else if pickerView == selectModifyMoney {
            if (component == 0){
                print("列: \(row)")
                print("値: \(userChoice[row])")
                uChoiceM = userChoice[row] as! String//誰が
                userRowNumM = row
            }else if (component == 1){
                print("列: \(row)")
                print("値: \(moneyChoice[row])")
                mChoiceM = (moneyChoice[row] as AnyObject).int64Value//何円
            }
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addMoney(_ sender: UIButton) {
        Money = Int64(totalMoney[userRowNum].text!)! + mChoice
        drinkNum = Money/20
        totalMoney[userRowNum].text = Money.description
        drinkLeft[userRowNum].text = drinkNum.description
        InitMoney[userRowNum] = Money.description
        InitDrinkNum[userRowNum] = drinkNum.description
        defaults.set(InitMoney, forKey: "DataMoney")
        defaults.set(InitDrinkNum, forKey: "DataDrinkNum")
        print(defaults.array(forKey: "DataMoney") as Any)
    }
    
    @IBAction func modefyMoney(_ sender: UIButton) {
        Money = mChoiceM
        drinkNum = Money/20
        totalMoney[userRowNumM].text = Money.description
        drinkLeft[userRowNumM].text = drinkNum.description
        InitMoney[userRowNumM] = Money.description
        InitDrinkNum[userRowNumM] = drinkNum.description
        defaults.set(InitMoney, forKey: "DataMoney")
        defaults.set(InitDrinkNum, forKey: "DataDrinkNum")
        print(defaults.array(forKey: "DataMoney") as Any)
    }
 
}

