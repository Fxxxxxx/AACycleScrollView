//
//  ViewController.swift
//  Demo
//
//  Created by Aaron on 2019/4/15.
//  Copyright © 2019 Aaron. All rights reserved.
//

import UIKit
import SnapKit
let kScreenW = UIScreen.main.bounds.width

class ViewController: UIViewController {

    let arr = Array.init(repeating: "https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1565428872&di=a221ece51a9c6f3c919e2d6153e3ec1b&src=http://science.china.com.cn/images/attachement/jpg/site555/20150731/e89a8ffb139317251fea42.jpg", count: 5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setCycleView()
    }
    
    func setCycleView() {
        
        let aaCycle = AACycleScrollView.init(frame: .zero)
        view.addSubview(aaCycle)
        aaCycle.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(50)
            maker.left.right.equalToSuperview()
            maker.height.equalTo(200)
        }
        aaCycle.delegate = self
        aaCycle.dataSource = self
        
        //使用自定义cell
        aaCycle.pageControl.currentPageIndicatorTintColor = .black
        aaCycle.pageControl.pageIndicatorTintColor = .green
        aaCycle.autoScrollTimeInterval = 2
        
        aaCycle.scrollDirection = .horizontal
//        aaCycle.pageControl.center = .init(x: kScreenW - 15, y: 100)
//        aaCycle.pageControl.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi / 2)
        
    }

}

extension ViewController: AACycleScrollViewDelegate, AACycleScrollViewDataSource {
    
    func customCellClass(_ cycleView: AACycleScrollView) -> UICollectionViewCell.Type? {
//        return CustomCell.self
        return nil
    }
    
    func setCustomCell(_ cell: UICollectionViewCell, in index: Int, with cycleView: AACycleScrollView) {
        let cell = cell as! CustomCell
        cell.label.text = "custom Set at \(index):\(cell.label)"
        cell.label.textColor = .orange
    }
    
    func numbersOfItems(_ cycleView: AACycleScrollView) -> Int {
        return arr.count
    }
    
    func imageUrlStringForItem(in index: Int, with cycleView: AACycleScrollView) -> String? {
        return arr[index]
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
        label.backgroundColor = .white
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
