//
//  focusCursorView.swift
//  DYZB
//
//  Created by wangjiayu on 2019/4/17.
//  Copyright © 2019 wangjiayu. All rights reserved.
//

import UIKit
import AVFoundation

class FocusCursorView: UIImageView {
    
    weak var view:UIView?
    weak var deviceTool:DeviceTool?
    var name:String
    
    init(name: String,view:UIView,deviceTool:DeviceTool) {
        self.name = name
        self.view = view
        self.deviceTool = deviceTool
        super.init(image: UIImage(named: name))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FocusCursorView {
    //点击屏幕时,将点转换为摄像头上的点
    func convertPoint(point:CGPoint) {
        //把当前位置转换到摄像头上的位置
        guard let camerPoint = deviceTool?.previewLayer?.captureDevicePointConverted(fromLayerPoint: point) else { return }
        //设置聚焦点光标位置
        setFocusCursorWithPoint(point)
        //设置聚焦
        focusWithMode(fucusMode:AVCaptureDevice.FocusMode.autoFocus, exposureMode: AVCaptureDevice.ExposureMode.autoExpose, point: camerPoint)
    }
    
    //设置聚焦光标位置
    fileprivate func setFocusCursorWithPoint(_ point:CGPoint) {
        self.center = point
        self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        self.alpha = 1.0
        UIView.animate(withDuration: 1.0, animations: {
            self.transform = CGAffineTransform.identity
        }) { (_) in
            self.alpha = 0.0
        }
    }
    
    //设置聚焦
    fileprivate func focusWithMode(fucusMode:AVCaptureDevice.FocusMode,exposureMode:AVCaptureDevice.ExposureMode,point:CGPoint) {
        guard let captureDevice = deviceTool?.currentVideoDeviceInput.device else { return }
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
