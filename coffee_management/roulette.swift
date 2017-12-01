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
    var winner:String = ""
    let result = UILabel()
    private var myImageView: UIImageView!
    private var myImageView2: UIImageView!
    let pieChartView = PieChart()

    override func viewDidLoad() {
        super.viewDidLoad()

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
        lottery.frame = CGRect(x:300 ,y: 700,width: 150,height: 50)
        lottery.setTitleColor(UIColor.white, for: .normal)
        lottery.setTitle("lottery", for: .normal)
        lottery.backgroundColor = UIColor.blue
        lottery.addTarget(self, action: #selector(roulette.hitDeterminator(sender:)), for: .touchUpInside)
        
        view.addSubview(lottery)
        
        //結果表示ラベル
        //let result = UILabel()
        result.frame = CGRect(x:300,y: 80,width: 150,height: 50)
        //result.backgroundColor = UIColor.blue
        result.textColor = UIColor.black
        result.textAlignment = NSTextAlignment.center
        result.text = ""
        
        view.addSubview(result)
        
        }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //let pieChartView = PieChart()
        //円グラフのやつだけどできてない
            pieChartView.frame = CGRect(x: 0, y: 200, width: view.frame.size.width, height: 390)
            pieChartView.segments = [
            Segment(color: UIColor.red, value: 10),
            Segment(color: UIColor.purple, value: 10),
            Segment(color: UIColor.magenta, value: 10),
            Segment(color: UIColor.orange, value: 10),
            Segment(color: UIColor.yellow, value: 10),
            Segment(color: UIColor.green, value: 10),
            Segment(color: UIColor.cyan, value: 10),
            Segment(color: UIColor.brown, value: 10),
            Segment(color: UIColor.lightGray, value: 10),
            Segment(color: UIColor.lightGray, value: 10)
        ]
    }
    
    @objc func hitDeterminator(sender: UIButton) {
        //当たりが出るかどうかの演算
        self.myImageView.transform = CGAffineTransform(rotationAngle: 0)
        let goRoulette2 = storyboard!.instantiateViewController(withIdentifier: "roulette2")
        
        let chooseResult = Int(arc4random_uniform(1))//0~49までの整数をランダムで生成
        if chooseResult == 0 {
            //勝者が誰かの演算
            let chooseWiner = Int(arc4random_uniform(UInt32(self.delegate.users.count)))
            //print("\(self.delegate.users[chooseWiner]) wins")
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
                //ルーレットが消えて円グラフが現れるアニメーション
//                UIView.transition(with: self.myImageView, duration: 2.0, options: [.transitionCrossDissolve, .autoreverse], animations: {
//                    self.myImageView.isHidden = true
//                    }) { _ in
//                    self.view.addSubview(self.pieChartView)
//                    }
                    //let goRoulette2 = self.storyboard!.instantiateViewController(withIdentifier: "roulette2")
                    //self.present(goRoulette2,animated: true, completion: nil)
                
                // 円グラフ回転アニメーション
//                    UIView.animate(withDuration: 8.0,animations: { () -> Void in
//                        for _ in 0..<10 {
//                            self.pieChartView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 1))
//                            self.pieChartView.transform = CGAffineTransform(rotationAngle: 0)
//                        }
//                    // 回転用のアフィン行列を生成.
//                        self.pieChartView.transform = CGAffineTransform(rotationAngle: angle)
//                    },
//                        completion: { (Bool) -> Void in
//                        self.result.text = "\(self.delegate.users[chooseWiner]) wins"
//                    })
            })
            //let goMain = storyboard!.instantiateViewController(withIdentifier: "ViewController")
            //self.present(goMain,animated: true, completion: nil)

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
   

    

