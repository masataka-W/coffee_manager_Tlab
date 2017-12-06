//
//  roulette.swift
//  coffee_management
//
//  Created by Masataka W. on 2017/11/30.
//  Copyright © 2017年 Masataka W. All rights reserved.
//

import Foundation
import UIKit

class roulette: UIViewController {
    
    var delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let defaults = UserDefaults.standard
    var winner:String = ""
    let result = UILabel()
    private var myImageView: UIImageView!
    private var myImageView2: UIImageView!
    var InitMoney: [String] = []
    var InitDrinkNum: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        InitMoney = defaults.array(forKey: "DataMoney") as! [String]
        InitDrinkNum = defaults.array(forKey: "DataDrinkNum") as! [String]

        // UIImageViewのサイズを設定する
        let iWidth: CGFloat = 400//ルーレット用
        let iHeight: CGFloat = 400//ルーレット用
        
        let jWidth: CGFloat = 110//針用
        let jHeight: CGFloat = 40//針用
        
        // UIImageViewのx,yを設定する
        let posX: CGFloat = (self.view.bounds.width - iWidth)/2//ルーレット
        let posY: CGFloat = 200//ルーレット
        
        let NposX: CGFloat = 580//針
        let NposY: CGFloat = 374//針
        
        // UIImageViewを作成.
        myImageView = UIImageView(frame: CGRect(x:posX, y:posY, width:iWidth, height:iHeight))//ルーレット
        myImageView2 = UIImageView(frame: CGRect(x:NposX, y:NposY, width:jWidth, height:jHeight))//針
        
        // UIImageを作成.
        let Roulette: UIImage = UIImage(named: "roulette.jpg")!
        let Needle: UIImage = UIImage(named: "needle.jpg")!
        // 画像をUIImageViewに設定する.
        myImageView.image = Roulette
        myImageView2.image = Needle
        // UIImageViewをViewに追加する
        self.view.addSubview(myImageView)
        self.view.addSubview(myImageView2)
        
        //ルーレット開始ボタン
        let lottery = UIButton(type: .custom)
        lottery.frame = CGRect(x:300 ,y: 750,width: 150,height: 50)
        lottery.setTitleColor(UIColor.white, for: .normal)
        lottery.setTitle("lottery", for: .normal)
        lottery.backgroundColor = UIColor.blue
        lottery.addTarget(self, action: #selector(roulette.hitDeterminator(sender:)), for: .touchUpInside)
        
        view.addSubview(lottery)
        
        //結果表示ラベル
        //let result = UILabel()
        result.frame = CGRect(x:300,y: 100,width: 150,height: 50)
        //result.backgroundColor = UIColor.blue
        result.textColor = UIColor.black
        result.textAlignment = NSTextAlignment.center
        result.text = ""
        
        view.addSubview(result)
        
        }
    
    @objc func hitDeterminator(sender: UIButton) {
        
        self.myImageView.transform = CGAffineTransform(rotationAngle: 0)
        let goRoulette2 = storyboard!.instantiateViewController(withIdentifier: "roulette2")
        
        //当たりが出るかどうかの演算
        let chooseResult = Int(arc4random_uniform(1))//0~49までの整数をランダムで生成
        if chooseResult == 0 {
            //勝者が誰かの演算
            let chooseWiner = Int(arc4random_uniform(UInt32(self.delegate.users.count)))//user配列の何番目かが得られる
            self.delegate.win = chooseWiner//勝った人の配列番号を受け渡す(roulette2で使う)
            //勝った人のフリードリンクを+1更新する
            let lucky = Int64(InitDrinkNum[chooseWiner])! + 1
            InitDrinkNum[chooseWiner] = lucky.description
            defaults.set(InitDrinkNum, forKey: "DataDrinkNum")
            
            // radianで回転角度を指定
            let angle:CGFloat = CGFloat(M_PI_2*1.9)
            
            // 当たりアニメーションの秒数を設定(8秒)
            UIView.animate(withDuration: 8.0,animations: { () -> Void in
                for _ in 0..<10 {
                    self.myImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 1))
                    self.myImageView.transform = CGAffineTransform(rotationAngle: 0)
                }
                // 回転用のアフィン行列を生成.
                self.myImageView.transform = CGAffineTransform(rotationAngle: angle)
            },
                
                completion: { (Bool) -> Void in
                //当たり表示
                self.result.text = "Jack Pod!!!"
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    // n秒後に実行したい処理
                    self.present(goRoulette2,animated: true, completion: nil)
                }
            })

        } else {
            //ハズレ演出----------------------------------------------------------------------------------
            let routateNum = Int(arc4random_uniform(12))
            let angle:CGFloat = CGFloat(30*routateNum)
            
            // アニメーションの秒数を設定(8秒)
            UIView.animate(withDuration: 8.0,animations: { () -> Void in
                for _ in 0..<10 {
                    self.myImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 1))
                    self.myImageView.transform = CGAffineTransform(rotationAngle: 0)
                }
                // 回転用のアフィン行列を生成.
                self.myImageView.transform = CGAffineTransform(rotationAngle: angle)
            },
                           completion: { (Bool) -> Void in
                            self.result.text = "nobody wins"
            })
            //let goMain = storyboard!.instantiateViewController(withIdentifier: "ViewController")
            //self.present(goMain,animated: true, completion: nil)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
}

