//
//  AACycleScrollView.swift
//  uchain
//
//  Created by Fxxx on 2018/11/19.
//  Copyright © 2018 Fxxx. All rights reserved.
//

import UIKit
import Kingfisher

public class AACycleScrollView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    public weak var delegate: AACycleScrollViewDelegate?
    public var imagesUrlStringGroup = [String]()
    public var imagesNameStringGroup = [String]()
    public let pageControl = UIPageControl()
    public var pageControlOffset : UIOffset?
    public var bannerImageViewContentMode = ContentMode.scaleAspectFill
    public var placeHolderImage: UIImage?
    public var autoScrollTimeInterval: TimeInterval = 2.0
    private let layout = UICollectionViewFlowLayout()
    private var timer: Timer?
    private var mainView: UICollectionView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }
    
    public init(frame: CGRect, imagesUrlStringGroup: [String]) {
        
        super.init(frame: frame)
        self.imagesUrlStringGroup = imagesUrlStringGroup
        buildUI()
        
    }
    
    public init(frame: CGRect, imagesNameStringGroup: [String]) {

        super.init(frame: frame)
        self.imagesNameStringGroup = imagesNameStringGroup
        buildUI()
        
    }
    
    func buildUI() {
        
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        mainView = UICollectionView.init(frame: self.bounds, collectionViewLayout: layout)
        mainView.dataSource = self
        mainView.delegate = self
        mainView.isPagingEnabled = true
        mainView.register(AABannerCell.self, forCellWithReuseIdentifier: "Banner")
        mainView.showsVerticalScrollIndicator = false
        mainView.showsHorizontalScrollIndicator = false
        self.addSubview(mainView)
        
        pageControl.frame = CGRect.init(x: 0, y: self.bounds.height - 30, width: self.bounds.size.width, height: 30)
        if pageControlOffset != nil {
            pageControl.center.x += pageControlOffset!.horizontal
            pageControl.center.y += pageControlOffset!.vertical
        }
        pageControl.currentPage = 0
        pageControl.numberOfPages = collectionView(mainView, numberOfItemsInSection: 0)
        self.addSubview(pageControl)
        setTimer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(invalidateTimer), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setTimer), name: UIApplication.didBecomeActiveNotification, object: self)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func removeFromSuperview() {
        invalidateTimer()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public func reloadData() {
        
        mainView.reloadData()
        pageControl.numberOfPages = self.collectionView(mainView, numberOfItemsInSection: 0)
        pageControl.currentPage = currentIndex()
        
    }
    
    @objc func autoScroll() {
        
        let total = collectionView(mainView, numberOfItemsInSection: 0)
        guard total > 0 else {
            return
        }
        var nextIndex = currentIndex() + 1
        nextIndex %= total
        mainView.selectItem(at: IndexPath.init(item: nextIndex, section: 0), animated: nextIndex != 0, scrollPosition: .left)
        pageControl.currentPage = nextIndex
        
    }
    
    func currentIndex() -> Int {
        
        return Int(mainView.contentOffset.x / self.bounds.size.width + 0.3)
        
    }
    
    @objc func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func setTimer() {
        invalidateTimer()
        timer = Timer.scheduledTimer(timeInterval: autoScrollTimeInterval, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
    }
    
}

extension AACycleScrollView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesNameStringGroup.count > 0 ? imagesNameStringGroup.count : imagesUrlStringGroup.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Banner", for: indexPath) as! AABannerCell
        cell.imageView.contentMode = self.bannerImageViewContentMode
        if imagesNameStringGroup.count > 0 {
            cell.imageView.image = UIImage.init(named: imagesNameStringGroup[indexPath.item])
        } else {
            cell.imageView.kf.setImage(with: URL.init(string: imagesUrlStringGroup[indexPath.item]), placeholder: placeHolderImage)
        }
        return cell
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.cycleScrollView?(self, didSelected: indexPath.item)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        invalidateTimer()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        setTimer()
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = currentIndex()
    }
    
}
