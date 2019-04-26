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
        aaCycle.delegate = self
        //默认使用图片数组
//        aaCycle.imagesUrlStringGroup = Array.init(repeating: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1555302881669&di=8e62c103a951f6d5df1f1ef9b7d7dcf3&imgtype=0&src=http%3A%2F%2Ff.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2Fd788d43f8794a4c240e9466f0ef41bd5ac6e39af.jpg", count: 5)
        
        //使用自定义cell
        aaCycle.cycleType = .custom
        aaCycle.numberOfCustomCells = 6
//        aaCycle.pageControlOffset = UIOffset.init(horizontal: kScreenW / 2 - 50, vertical: 0)
        aaCycle.pageControl.currentPageIndicatorTintColor = .black
        aaCycle.pageControl.pageIndicatorTintColor = .green
        aaCycle.autoScrollTimeInterval = 2
        view.addSubview(aaCycle)
        
        aaCycle.scrollDirection = .vertical
        aaCycle.pageControl.center = .init(x: kScreenW - 15, y: 100)
        aaCycle.pageControl.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi / 2)
        
    }

}

extension ViewController: AACycleScrollViewDelegate {
    
    func customCellClassFor(cycleScrollView: AACycleScrollView) -> UICollectionViewCell.Type {
        return CustomCell.self
    }
    
    func setCustomCell(cycleScrollView: AACycleScrollView, customCell: UICollectionViewCell, index: Int) {
        let cell = customCell as! CustomCell
        cell.label.text = "custom Set at \(index):\(cell.label)"
        cell.label.textColor = .orange
    }
    
    func cycleScrollView(_: AACycleScrollView, didSelected index: Int) {
        print("tap at: \(index)")
    }
    
    func cycleScrollView(_: AACycleScrollView, scrollTo index: Int) {
        print("scroll to: \(index)")
    }
    
}

class CustomCell: UICollectionViewCell {
    
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.frame = frame
        label.textColor = .red
        label.font = .boldSystemFont(ofSize: 24)
        label.text = .init(describing: self)
        label.numberOfLines = 0
        self.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        label.frame = self.bounds
    }
}
