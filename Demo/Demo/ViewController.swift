//
//  ViewController.swift
//  Demo
//
//  Created by Aaron on 2019/4/15.
//  Copyright © 2019 Aaron. All rights reserved.
//

import UIKit
let kScreenW = UIScreen.main.bounds.width

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setCycleView()
    }
    
    func setCycleView() {
        
        let aaCycle = AACycleScrollView.init(frame: CGRect.init(x: 0, y: 80, width: kScreenW, height: 200))
        aaCycle.imagesUrlStringGroup = Array.init(repeating: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1555302881669&di=8e62c103a951f6d5df1f1ef9b7d7dcf3&imgtype=0&src=http%3A%2F%2Ff.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2Fd788d43f8794a4c240e9466f0ef41bd5ac6e39af.jpg", count: 5)
        aaCycle.autoScrollTimeInterval = 2
        aaCycle.pageControlOffset = UIOffset.init(horizontal: kScreenW / 2 - 50, vertical: 0)
        view.addSubview(aaCycle)
        
    }
    

}

