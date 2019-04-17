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
    private lazy var focusCursorImageView : UIImageView = {
        let focusCursorImageView = UIImageView(image: UIImage(named: "focus"))
        return focusCursorImageView
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
        
        view.addSubview(focusCursorImageView)
    }
}

// MARK: - 事件监听
extension RoomViewController {
    @objc fileprivate func rightItemClick() {
        playerTool.changeCameraDevicePosition()
    }
    
    //点击屏幕出现聚焦视图
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //获取点击位置
        guard let touchPoint = touches.first?.location(in: view) else { return }
        //把当前位置转换到摄像头上的位置
        guard let camerPoint = playerTool.previewLayer?.captureDevicePointConverted(fromLayerPoint: touchPoint) else { return }
        //设置聚焦点光标位置
        setFocusCursorWithPoint(touchPoint)
        //设置聚焦
        focusWithMode(fucusMode:AVCaptureDevice.FocusMode.autoFocus, exposureMode: AVCaptureDevice.ExposureMode.autoExpose, point: camerPoint)
    }
}

extension RoomViewController {
    fileprivate func setFocusCursorWithPoint(_ point:CGPoint) {
        focusCursorImageView.center = point
        focusCursorImageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        focusCursorImageView.alpha = 1.0
        UIView.animate(withDuration: 1.0, animations: {
            self.focusCursorImageView.transform = CGAffineTransform.identity
        }) { (_) in
            self.focusCursorImageView.alpha = 0.0
        }
    }
    
    fileprivate func focusWithMode(fucusMode:AVCaptureDevice.FocusMode,exposureMode:AVCaptureDevice.ExposureMode,point:CGPoint) {
        let captureDevice = playerTool.currentVideoDeviceInput.device
        //锁定配置
        try? captureDevice.lockForConfiguration()
        
        //设置聚焦
        if captureDevice.isFocusModeSupported(AVCaptureDevice.FocusMode.autoFocus) {
            captureDevice.focusMode = AVCaptureDevice.FocusMode.autoFocus
        }
        if captureDevice.isFocusPointOfInterestSupported {
            captureDevice.focusPointOfInterest = point
        }
        
        //设置曝光
        if captureDevice.isExposureModeSupported(AVCaptureDevice.ExposureMode.autoExpose) {
            captureDevice.exposureMode = AVCaptureDevice.ExposureMode.autoExpose
        }
        if captureDevice.isExposurePointOfInterestSupported {
            captureDevice.exposurePointOfInterest = point
        }
        
        //解锁配置
        captureDevice.unlockForConfiguration()
    }
}
