//
//  BaseViewController.swift
//  DYZB
//
//  Created by wangjiayu on 2018/12/2.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    //定义属性
    var contentView:UIView?
    
    // MARK: - 懒加载属性
    private lazy var animImageView:UIImageView = { [unowned self] in 
        let imageView = UIImageView(image: UIImage(named: "img_loading_1"))
        let point = CGPoint(x: view.center.x, y: view.center.y - 50)
        imageView.center = point
        imageView.animationImages = [UIImage(named: "img_loading_1")!,UIImage(named: "img_loading_2")!]
        imageView.autoresizingMask = [.flexibleTopMargin,.flexibleBottomMargin]
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

}

extension BaseViewController {
    @objc func setupUI() {
        //先隐藏内容视图
        contentView?.isHidden = true
        //设置动画并执行
        animImageView.animationDuration = 0.5
        animImageView.animationRepeatCount = LONG_MAX
        animImageView.startAnimating()
        //显示加载时的动图
        view.addSubview(animImageView)
        //设置背景色
        view.backgroundColor = UIColor.white
    }
}

extension BaseViewController {
    func loadDataFinished() {
        animImageView.stopAnimating()
        animImageView.isHidden = true
        contentView?.isHidden = false
    }
}
