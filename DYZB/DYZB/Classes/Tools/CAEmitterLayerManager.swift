//
//  CAEmitterLayerManager.swift
//  DYZB
//
//  Created by wangjiayu on 2018/12/4.
//  Copyright © 2018 wangjiayu. All rights reserved.
//  粒子发射器

import UIKit


class CAEmitterLayerManager : CALayer{

    // MARK: - 定义属性
    var image:UIImage
    var layer:CALayer
    var postion:CGPoint
    
    // MARK: - 懒加载
    //粒子发射器
    lazy var emitterLayer:CAEmitterLayer = {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterPosition = self.postion
        return emitterLayer
    }()
    
    init(image:UIImage,layer:CALayer,postion:CGPoint) {
        self.image = image
        self.layer = layer
        self.postion = postion
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CAEmitterLayerManager {
    //设置粒子
     func startEmitterCellAnimation(){
        //创建粒子
        let cell = CAEmitterCell()
        
        //设置粒子属性
        //设置每秒钟粒子发出的数量
        cell.birthRate = 10
        
        //设置粒子的生存时间
        cell.lifetime = 5
        cell.lifetimeRange = 2
        
        //设置粒子缩放
        cell.scale = 0.7
        cell.scaleRange = 0.3
        
        //设置粒子发射方向
        cell.emissionLongitude = CGFloat(Double.pi/2)
        cell.emissionRange = CGFloat(Double.pi/3)
        
        //设置粒子的发射速度
        cell.velocity = 100
        cell.velocityRange = 250
        
        //设置粒子图片
        cell.contents = image.cgImage
        
        //设置粒子旋转
        cell.spin = 1.0
        cell.spinRange = 0.5
        
        //添加粒子到发射器中
        emitterLayer.emitterCells = [cell]
        //将发射器添加到图层中
        layer.addSublayer(emitterLayer)
    }
}
