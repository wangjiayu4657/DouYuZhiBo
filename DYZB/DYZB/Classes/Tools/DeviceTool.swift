//
//  DeviceTool.swift
//  DYZB
//
//  Created by wangjiayu on 2019/4/16.
//  Copyright © 2019 wangjiayu. All rights reserved.
//

import UIKit
import AVFoundation

class DeviceTool: NSObject {
    var currentVideoDeviceInput:AVCaptureDeviceInput!
    var videoConnection:AVCaptureConnection!
    var session:AVCaptureSession!
    
    var previewLayer:AVCaptureVideoPreviewLayer?
}

// MARK: - 初始化
extension DeviceTool {
     func initializeDevice() -> AVCaptureVideoPreviewLayer? {
        //1.创建会话
        session = AVCaptureSession()
        
        //获取摄像头设备
        guard let videoDevice = getVideoDeivce(position: .front) else { return nil }
        //创建视频输入源对象
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else { return nil }
        currentVideoDeviceInput = videoDeviceInput
        //将视频输入源添加到会话中
        if session.canAddInput(videoDeviceInput) {session.addInput(videoDeviceInput)}
        
        //获取麦克风设备
        guard let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio) else { return nil }
        //创建音频输入源对象
        guard let audioDeviceInput = try? AVCaptureDeviceInput(device: audioDevice) else { return nil }
        //将音频输入源对象添加到会话中
        if session.canAddInput(audioDeviceInput) { session.addInput(audioDeviceInput)}
        
        //获取视频输出设备
        let videoDeviceOutput = AVCaptureVideoDataOutput()
        //创建串行队列
//        let videoQueue = DispatchQueue(label: "Video Capture Queue")
        let videoQueue = dispatch_queue_serial_t(label: "Video Capture Queue")
        //设置代理,捕获采集的视频数据
        videoDeviceOutput.setSampleBufferDelegate(self, queue: videoQueue)
        if session.canAddOutput(videoDeviceOutput) { session.addOutput(videoDeviceOutput)}
        
        //获取音频输出设备
        let audioDeviceOutput = AVCaptureAudioDataOutput()
        //创建串行队列
//        let audioQueue = DispatchQueue(label: "Audio Capture Queue")
        let audioQueue = dispatch_queue_serial_t(label: "Audio Capture Queue")
        //设置代理,捕获采集到的音频数据
        audioDeviceOutput.setSampleBufferDelegate(self, queue: audioQueue)
        if session.canAddOutput(audioDeviceOutput) { session.addOutput(audioDeviceOutput)}
        
        //获取视频输入与输出连接,用于区分音视频数据
        videoConnection = videoDeviceOutput.connection(with: AVMediaType.video)
        
        //添加预览层
        let playerView = AVCaptureVideoPreviewLayer(session: session)
        playerView.frame = UIScreen.main.bounds
        
        previewLayer = playerView
        return playerView
    }
    
    func startRunning() {
        session.startRunning()
    }
    
    //获取前置/后置摄像头
    fileprivate func getVideoDeivce(position:AVCaptureDevice.Position) -> AVCaptureDevice? {
       let devices = AVCaptureDevice.devices(for: AVMediaType.video)
        for device in devices {
            if device.position == position {
                return device
            }
        }
        return nil
    }
    
    //切换摄像头
    func changeCameraDevicePosition() {
        //先获取当前设备的方向
        let position = currentVideoDeviceInput.device.position
        //目标方向
        let targetPosition = position == AVCaptureDevice.Position.front ? AVCaptureDevice.Position.back : AVCaptureDevice.Position.front
        //获取选需要改变的摄像头设备
        guard let device = self.getVideoDeivce(position: targetPosition) else { return }
        //获取改变的摄像头输入设备
        guard let deviceInput = try? AVCaptureDeviceInput(device: device) else { return }
        //移除之前的摄像头输入设备
        session.removeInput(currentVideoDeviceInput)
        //添加新的摄像头输入设备
        if session.canAddInput(deviceInput) { session.addInput(deviceInput) }
        //记录当前的摄像头输入设备
        currentVideoDeviceInput = deviceInput
    }
}

// MARK: - 遵守AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate代理协议
extension DeviceTool : AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if videoConnection == connection {
//            print("video:\(sampleBuffer)")
        }else {
//            print("audio:\(sampleBuffer)")
        }
    }
}


