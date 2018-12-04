//
//  ShowRoomViewController.swift
//  DYZB
//
//  Created by wangjiayu on 2018/12/2.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit

class ShowRoomViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        
        startSnow()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }

}

extension ShowRoomViewController {
    private func startSnow() {
        let manager = CAEmitterLayerManager(image: UIImage(named: "snow")!,layer:view.layer, postion: CGPoint(x:view.bounds.width * 0.5, y: -20))
        manager.startEmitterCellAnimation()
    }
}


