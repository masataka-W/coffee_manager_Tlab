//
//  roulette2.swift
//  coffee_management
//
//  Created by Masataka W. on 2017/11/30.
//  Copyright © 2017年 Masataka W. All rights reserved.
//円グラフ表示したいけどできてない

import Foundation
import UIKit

class roulette2: UIViewController {
    
    var delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let result = UILabel()
    private var ImageView: UIImageView!
    private var ImageView2: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UIImageViewのサイズを設定する
        let iWidth: CGFloat = 500//ルーレット用
        let iHeight: CGFloat = 500//ルーレット用

        let jWidth: CGFloat = 260//針用
        let jHeight: CGFloat = 70//針用

        // UIImageViewのx,yを設定する
        let posX: CGFloat = (self.view.bounds.width - iWidth)/2//ルーレット
        let posY: CGFloat = 150//ルーレット

        let NposX: CGFloat = (self.view.bounds.width - jWidth)/2//針
        let NposY: CGFloat = 355//針

        // UIImageViewを作成.
        ImageView = UIImageView(frame: CGRect(x:posX, y:posY, width:iWidth, height:iHeight))//ルーレット
        ImageView2 = UIImageView(frame: CGRect(x:NposX, y:NposY, width:jWidth, height:jHeight))//針

        // UIImageを作成.
        let Roulette2: UIImage = UIImage(named: "roulette2.png")!
        let Needle2: UIImage = UIImage(named: "needle2.png")!
        // 画像をUIImageViewに設定する.
        ImageView.image = Roulette2
        ImageView2.image = Needle2
        // UIImageViewをViewに追加する
        self.view.addSubview(ImageView)
        self.view.addSubview(ImageView2)

        //ルーレット開始ボタン
        let lottery2 = UIButton(type: .custom)
        lottery2.frame = CGRect(x:300 ,y: 750,width: 150,height: 50)
        lottery2.setTitleColor(UIColor.white, for: .normal)
        lottery2.setTitle("Who wins?", for: .normal)
        lottery2.backgroundColor = UIColor.blue
        lottery2.addTarget(self, action: #selector(roulette2.hitDeterminator2(sender:)), for: .touchUpInside)

        view.addSubview(lottery2)

        //結果表示ラベル
        //let result = UILabel()
        result.frame = CGRect(x:300,y: 100,width: 150,height: 50)
        //result.backgroundColor = UIColor.blue
        result.textColor = UIColor.black
        result.textAlignment = NSTextAlignment.center
        result.text = ""

        view.addSubview(result)
        

    }
    
    @objc func hitDeterminator2(sender: UIButton) {
        
        //当たった人に対して個別に最後に回転する針の角度を決定する
        var angle:CGFloat = CGFloat(0)
        
        switch self.delegate.win {
            
        case 0: angle = CGFloat(M_PI / 180 * Double(90))
            
        case 1: angle = CGFloat(M_PI / 180 * Double(126))
            
        case 2: angle = CGFloat(M_PI / 180 * Double(162))
            
        case 3: angle = CGFloat(M_PI / 180 * Double(198))
            
        case 4: angle = CGFloat(M_PI / 180 * Double(234))
            
        case 5: angle = CGFloat(M_PI / 180 * Double(270))
            
        case 6: angle = CGFloat(M_PI / 180 * Double(306))
            
        case 7: angle = CGFloat(M_PI / 180 * Double(342))
            
        case 8: angle = CGFloat(M_PI / 180 * Double(18))
            
        case 9: angle = CGFloat(M_PI / 180 * Double(54))
            
        default:
            print("roulette2のswitch文でエラー")
            
        }

        self.ImageView2.transform = CGAffineTransform(rotationAngle: 0)
        let goMain = storyboard!.instantiateViewController(withIdentifier: "main")

            // 当たりアニメーションの秒数を設定(8秒)
            UIView.animate(withDuration: 8.0,animations: { () -> Void in
                for _ in 0..<10 {
                    self.ImageView2.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 1))
                    self.ImageView2.transform = CGAffineTransform(rotationAngle: 0)
                }
                
                // 回転用のアフィン行列を生成.
                self.ImageView2.transform = CGAffineTransform(rotationAngle: angle)
            },

                           completion: { (Bool) -> Void in
                            //当たり表示
                            self.result.text = self.delegate.users[self.delegate.win] + " wins"

                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                // n秒後に実行したい処理
                                self.present(goMain,animated: true, completion: nil)
                            }
            })

        }
    
    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
    }
    
}
