//
//  PieChartView.swift
//  coffee_management
//
//  Created by Masataka W. on 2017/11/30.
//  Copyright © 2017年 Masataka W. All rights reserved.
//

import Foundation
import UIKit

struct Segment {
    
    var color: UIColor
    var angle: CGFloat
    
}

@IBDesignable
class PieChartView: UIView {
    
    var segments = [Segment]() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.clear
        self.drawPieChart(rect: rect)
    }
    
    func drawPieChart(rect: CGRect) {
        // コンテキストを取得
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        // Pieの中心位置
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.3)
        
        // Pieの半径
        let radius = min(rect.width, rect.height) * 0.5
        
        // 開始角度(ラジアン) 右回りにするため-90度
        var startAngle = CGFloat(-90.0 * .pi/180)
        
        self.segments.forEach { (segment) in
            // Pieの色を設定
            context.setFillColor(segment.color.cgColor)
            
            // 終了角度(ラジアン) 右回りにするため-90度
            let endAngle = (segment.angle - 90.0) * .pi/180
            
            // 描画位置を移動
            context.move(to: center)
            
            // Pieを追加
            context.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            context.fillPath()
            
            startAngle = endAngle
        }
    }
    
}

