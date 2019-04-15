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
    public var imagesUrlStringGroup = [String]() {
        didSet {
            reloadData()
        }
    }
    public var imagesNameStringGroup = [String]() {
        didSet {
            reloadData()
        }
    }
    private var totalCount = 0
    public let pageControl = UIPageControl()
    public var pageControlOffset : UIOffset? {
        didSet {
            pageControl.center.x += pageControlOffset!.horizontal
            pageControl.center.y += pageControlOffset!.vertical
        }
    }
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
        mainView.backgroundColor = .white
        mainView.register(AABannerCell.self, forCellWithReuseIdentifier: "Banner")
        mainView.showsVerticalScrollIndicator = false
        mainView.showsHorizontalScrollIndicator = false
        self.addSubview(mainView)
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = imagesNameStringGroup.count > 0 ? imagesNameStringGroup.count : imagesUrlStringGroup.count
        self.addSubview(pageControl)
        pageControl.sizeToFit()
        pageControl.center = CGPoint.init(x: self.bounds.width / 2, y: self.bounds.height - 15)
        
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
        totalCount = imagesNameStringGroup.count > 0 ? imagesNameStringGroup.count : imagesUrlStringGroup.count
        guard totalCount > 1 else {
            mainView.isScrollEnabled = false
            pageControl.isHidden = true
            invalidateTimer()
            return
        }
        mainView.isScrollEnabled = true
        pageControl.isHidden = false
        setTimer()
        pageControl.numberOfPages = totalCount
        mainView.scrollToItem(at: IndexPath.init(item: 1, section: 0), at: .left, animated: false)
        pageControl.currentPage = 0
        
    }
    
    @objc func autoScroll() {
        
        let total = collectionView(mainView, numberOfItemsInSection: 0)
        guard total > 0 else {
            return
        }
        var nextIndex = currentIndex() + 1
        nextIndex %= total
        mainView.scrollToItem(at: IndexPath.init(item: nextIndex, section: 0), at: .left, animated: true)
        
    }
    
    private func currentIndex() -> Int {
        
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
        return totalCount > 1 ? totalCount + 2 : totalCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Banner", for: indexPath) as! AABannerCell
        cell.imageView.contentMode = self.bannerImageViewContentMode
        var index = indexPath.item
        if index == 0 {
            index = totalCount - 1
        } else if index == totalCount + 1 {
            index = 0
        } else {
            index -= 1
        }
        if imagesNameStringGroup.count > 0 {
            cell.imageView.image = UIImage.init(named: imagesNameStringGroup[index])
        } else {
            cell.imageView.kf.setImage(with: URL.init(string: imagesUrlStringGroup[index]), placeholder: placeHolderImage)
        }
        return cell
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.cycleScrollView?(self, didSelected: indexPath.item - 1)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        invalidateTimer()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        setTimer()
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let page = currentIndex()
        if page == 0 {
            mainView.scrollToItem(at: IndexPath.init(item: totalCount, section: 0), at: .left, animated: false)
            pageControl.currentPage = totalCount - 1
            return
        } else if page == totalCount + 1 {
            mainView.scrollToItem(at: IndexPath.init(item: 1, section: 0), at: .left, animated: false)
            pageControl.currentPage = 0
            return
        }
        pageControl.currentPage = page - 1
    }
    
}
