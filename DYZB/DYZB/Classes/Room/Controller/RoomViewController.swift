//
//  RoomViewController.swift
//  DYZB
//
//  Created by wangjiayu on 2019/4/15.
//  Copyright © 2019 wangjiayu. All rights reserved.
//

import UIKit


class RoomViewController: UIViewController {

    // MARK: - 懒加载
    private lazy var playerTool:DeviceTool = DeviceTool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    
        setupUI()
    }
}

// MARK: - 设置UI界面
extension RoomViewController {
    private func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "切换摄像头", style: UIBarButtonItem.Style.plain, target: self, action: #selector(rightItemClick))
        
        initializePlayerTool()
    }
    
    private func initializePlayerTool() {
        guard let playerView = playerTool.initializeDevice() else { return }
        view.layer.insertSublayer(playerView, at: 1)
        playerTool.startRunning()
    }
}

// MARK: - 事件监听
extension RoomViewController {
    @objc fileprivate func rightItemClick() {
        playerTool.changeCameraDevicePosition()
    }
}
