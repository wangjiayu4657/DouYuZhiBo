//
//  RoomViewController.swift
//  DYZB
//
//  Created by wangjiayu on 2019/4/15.
//  Copyright © 2019 wangjiayu. All rights reserved.
//

import UIKit
import AVFoundation


class RoomViewController: UIViewController {
    
    // MARK: - 懒加载
    private lazy var focusCursorView : FocusCursorView = { [weak self] in
        let focusCursorView = FocusCursorView(name: "focus", view: view, deviceTool: playerTool)
        return focusCursorView
    }();
    
    private lazy var playerTool:DeviceTool = {
        let playerTool = DeviceTool()
        if let previewLayer = playerTool.initializeDevice() { view.layer.insertSublayer(previewLayer, at: 1) }
        return playerTool
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    
        setupUI()
    }
}

// MARK: - 设置UI界面
extension RoomViewController {
    private func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "切换摄像头", style: .plain, target: self, action: #selector(rightItemClick))
        
        playerTool.startRunning()
        
        view.addSubview(focusCursorView)
    }
}

// MARK: - 事件监听
extension RoomViewController {
    @objc fileprivate func rightItemClick() {
        playerTool.changeCameraDevicePosition()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //获取点击位置
        guard let touchPoint = touches.first?.location(in: view) else { return }
        focusCursorView.convertPoint(point: touchPoint)
    }
}
