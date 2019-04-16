//
//  RoomViewController.swift
//  DYZB
//
//  Created by wangjiayu on 2019/4/15.
//  Copyright © 2019 wangjiayu. All rights reserved.
//

import UIKit
import IJKMediaFramework

class RoomViewController: UIViewController {

    private var player:IJKMediaPlayback!
    
    private lazy var playBtn:UIButton = {
       let playBtn = UIButton(type: UIButton.ButtonType.custom)
        playBtn.setTitle("点击播放", for: UIControl.State.normal)
        playBtn.addTarget(self, action: #selector(playBtnClick), for: UIControl.Event.touchUpInside)
        playBtn.frame = CGRect(x: 150, y: 400, width: 100, height: 60)
        playBtn.backgroundColor = UIColor.randomColor()
        return playBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !player.isPlaying() {
            player.prepareToPlay()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.pause()
        player.stop()
    }
}


extension RoomViewController {
    private func setupUI() {
        
        //在线视频播放
//        guard let url = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4") else { return }
//        guard let player = IJKAVMoviePlayerController(contentURL: url) else { return }
        
        //直播视频
        guard let url = URL(string: "http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8") else { return }
        guard let player = IJKFFMoviePlayerController(contentURL: url, with: IJKFFOptions.byDefault()) else { return }
        
        guard let playerView = player.view else { return }
        self.player = player
        
        let displayView = UIView(frame: CGRect(x: 0, y: 200, width:view.bounds.size.width, height: 180))
        displayView.backgroundColor = UIColor.black
        view.addSubview(displayView)
        
        playerView.frame = displayView.bounds
        playerView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleWidth.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue)
        
        displayView.insertSubview(playerView, at: 1)
        player.scalingMode = .aspectFill
        
        //添加播放按钮
        view.addSubview(playBtn)
        
        installMovieNotificationObservers()
    }
}

// MARK: - Install/Remove Notification
extension RoomViewController {
    fileprivate func installMovieNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadStateDidChange(_:)), name: Notification.Name.IJKMPMoviePlayerLoadStateDidChange, object: player)
        
        NotificationCenter.default.addObserver(self, selector: #selector(moviePlayBackFinish(_:)), name: NSNotification.Name.IJKMPMoviePlayerPlaybackDidFinish, object: player)

        NotificationCenter.default.addObserver(self, selector: #selector(mediaIsPreparedToPlayDidChange(_:)), name: Notification.Name.IJKMPMediaPlaybackIsPreparedToPlayDidChange, object: player)

        NotificationCenter.default.addObserver(self, selector: #selector(moviePlayBackStateDidChange(_:)), name: NSNotification.Name.IJKMPMoviePlayerPlaybackStateDidChange, object: player)
    }
    
    fileprivate func removeMovieNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: .IJKMPMoviePlayerLoadStateDidChange, object: player)
        NotificationCenter.default.removeObserver(self, name: .IJKMPMoviePlayerPlaybackDidFinish, object: player)
        NotificationCenter.default.removeObserver(self, name: .IJKMPMediaPlaybackIsPreparedToPlayDidChange, object: player)
        NotificationCenter.default.removeObserver(self, name: .IJKMPMoviePlayerPlaybackStateDidChange, object: player)
    }
}


// MARK: - 事件监听
extension RoomViewController {
    
    @objc fileprivate func playBtnClick() {
        if player.isPlaying() {
            player.pause()
        }else {
            player.play()
        }
    }
    
    @objc fileprivate func loadStateDidChange(_ notify:Notification) {
        guard let loadState = player?.loadState else { return }
        if (loadState.rawValue & IJKMPMovieLoadState.playthroughOK.rawValue) != 0 {
            print("LoadStateDidChange: IJKMovieLoadStatePlayThroughOK: \(loadState)\n")
        }else if ((loadState.rawValue & IJKMPMovieLoadState.stalled.rawValue) != 0) {
            print("loadStateDidChange: IJKMPMovieLoadStateStalled: \(loadState)\n")
        }else {
            print("loadStateDidChange: ???: \(loadState)\n")
        }
    }
    
    @objc fileprivate func moviePlayBackFinish(_ notify:Notification) {
        let reason = notify.userInfo?[IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] as? Int
        switch reason {
        case IJKMPMovieFinishReason.playbackEnded.rawValue:
            print("playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: \(reason ?? 0)\n")
        case IJKMPMovieFinishReason.userExited.rawValue:
            print("playbackStateDidChange: IJKMPMovieFinishReasonUserExited: \(reason ?? 0)\n")
        case IJKMPMovieFinishReason.playbackError.rawValue:
            print("playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: \(reason ?? 0)\n")
        default:
            print("playbackPlayBackDidFinish: ???: \(reason ?? 0)\n")
        }
        
    }
    
    @objc fileprivate func mediaIsPreparedToPlayDidChange(_ notify:Notification) {
        print("mediaIsPrepareToPlayDidChange\n")
    }
    
    @objc fileprivate func moviePlayBackStateDidChange(_ notify:Notification) {
        guard let player = player else {
            print("player 为空")
            return
        }
        let value = player.playbackState.rawValue
        switch (value) {
            case IJKMPMoviePlaybackState.stopped.rawValue:
                print("IJKMPMoviePlayBackStateDidChange \(value): stoped")

            case IJKMPMoviePlaybackState.playing.rawValue:
                print("IJKMPMoviePlayBackStateDidChange \(value): playing")
            
            case IJKMPMoviePlaybackState.paused.rawValue:
                print("IJKMPMoviePlayBackStateDidChange \(value): paused" )
            
            case IJKMPMoviePlaybackState.interrupted.rawValue:
                print("IJKMPMoviePlayBackStateDidChange \(value): interrupted")
            
            case IJKMPMoviePlaybackState.seekingForward.rawValue,IJKMPMoviePlaybackState.seekingBackward.rawValue:
                print("IJKMPMoviePlayBackStateDidChange \(value): seeking")
            
            default:
                print("IJKMPMoviePlayBackStateDidChange \(value): unknown")
        }
    }
}
