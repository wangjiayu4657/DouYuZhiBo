//
//  PageTitleView.swift
//  DYZB
//
//  Created by wangjiayu on 2018/11/21.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit

class PageTitleView: UIView {
    // MARK: - 定义属性
    private var titles:[String]
    
    // MARK: - 懒加载
    private lazy var titleLbs:[UILabel] = [UILabel]()
    private lazy var titleScrollView:UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kTitleViewH))
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        return scrollView
    }()
    
    // MARK: - 自定义构造函数
    init(frame: CGRect,titles:[String]) {
        self.titles = titles
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置 UI 界面
extension PageTitleView {
    private func setupUI() {
        //加载titleScrollView
        addSubview(titleScrollView)
        
        //添加 titleLb
        createTitleLabel()
        
        //添加滑块
        createSliderView()

        //添加 bottomLine
        creatBottonLine()
        
    }
    
    //创建 titleLabel
    private func createTitleLabel() {
        let titleLbY:CGFloat = 0
        let titleLbW = kScreenW / CGFloat(titles.count)
        let titleLbH:CGFloat = 40
        
        for (index,title) in titles.enumerated() {
            //创建 label
            let titleLb = UILabel()
            
            //设置 label 属性
            titleLb.text = title
            titleLb.textColor = UIColor.darkGray
            titleLb.textAlignment = .center
            titleLb.font = UIFont.systemFont(ofSize: 15)
            
            //设置 labelt 的 frame
            titleLb.frame = CGRect(x: titleLbW * CGFloat(index), y: titleLbY, width: titleLbW, height: titleLbH)
            print(titleLb.frame)
            //添加 titleLb
            titleScrollView.addSubview(titleLb)
            titleLbs.append(titleLb)
        }
    }
    
    //添加 titleView 底部的滑块
    private func createSliderView() {
        guard let titleLb = titleLbs.first else { return }
        titleLb.textColor = UIColor.orange
        let sliderView = UIView(frame: CGRect(x: titleLb.frame.origin.x, y: kTitleViewH - 2, width: titleLb.frame.width, height: 2))
        sliderView.backgroundColor = UIColor.orange
        titleScrollView.addSubview(sliderView)
    }
    
    //添加 titleView 底部的细线
    private func creatBottonLine() {
        let bottomLine = UIView(frame: CGRect(x: 0, y: kTitleViewH - 0.5, width: kScreenW, height: 0.5))
        bottomLine.backgroundColor = UIColor.lightGray
        addSubview(bottomLine)
    }
    
}
