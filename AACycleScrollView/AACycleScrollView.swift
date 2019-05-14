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

    public enum AACycleType {
        case image
        case custom
    }
    
    public var cycleType: AACycleType = .image
    
    public weak var delegate: AACycleScrollViewDelegate? {
        didSet {
            if let cellClass = delegate?.customCellClassFor?(cycleScrollView: self) {
                mainView.register(cellClass, forCellWithReuseIdentifier: cellId_Custom)
            } else {
                mainView.register(delegate?.customCellNibFor?(cycleScrollView: self), forCellWithReuseIdentifier: cellId_Custom)
            }
        }
    }
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
    public var numberOfCustomCells: Int = 0 {
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
    public var scrollDirection = UICollectionView.ScrollDirection.horizontal {
        didSet {
            layout.scrollDirection = scrollDirection
            position = scrollDirection == .horizontal ? .left : .top
        }
    }
    private var position = UICollectionView.ScrollPosition.left
    private let layout = UICollectionViewFlowLayout()
    private var timer: Timer?
    private var mainView: UICollectionView!
    
    private let cellId_Image = "CELL_IMAGE"
    private let cellId_Custom = "CELL_CUSTOM"
    
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
        layout.scrollDirection = scrollDirection
        mainView = UICollectionView.init(frame: self.bounds, collectionViewLayout: layout)
        mainView.dataSource = self
        mainView.delegate = self
        mainView.isPagingEnabled = true
        mainView.backgroundColor = .white
        mainView.showsVerticalScrollIndicator = false
        mainView.showsHorizontalScrollIndicator = false
        self.addSubview(mainView)
        mainView.register(AABannerCell.self, forCellWithReuseIdentifier: cellId_Image)
        
        pageControl.frame = CGRect.init(x: 0, y: self.bounds.height - 30, width: self.bounds.width, height: 30)
        if let offset = pageControlOffset {
            pageControl.frame.origin.x += offset.horizontal
            pageControl.frame.origin.y += offset.vertical
        }
        self.addSubview(pageControl)
        
        reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(invalidateTimer), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setTimer), name: UIApplication.didBecomeActiveNotification, object: self)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        mainView.frame = self.bounds
        layout.itemSize = self.bounds.size
    }
    
    public override func removeFromSuperview() {
        invalidateTimer()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public func reloadData() {
        
        if cycleType == .image {
            totalCount = imagesNameStringGroup.count > 0 ? imagesNameStringGroup.count : imagesUrlStringGroup.count
        } else {
            totalCount = numberOfCustomCells
        }
        mainView.reloadData()
        guard totalCount > 1 else {
            mainView.isScrollEnabled = false
            pageControl.isHidden = true
            invalidateTimer()
            return
        }
        mainView.isScrollEnabled = true
        pageControl.isHidden = false
        pageControl.numberOfPages = totalCount
        pageControl.currentPage = totalCount - 1
        setTimer()
        
    }
    
    @objc func autoScroll() {
        
        let total = collectionView(mainView, numberOfItemsInSection: 0)
        guard total > 0 else {
            return
        }
        var nextIndex = currentIndex() + 1
        nextIndex %= total
        mainView.scrollToItem(at: IndexPath.init(item: nextIndex, section: 0), at: position, animated: true)
        
    }
    
    private func currentIndex() -> Int {
        
        if scrollDirection == .horizontal {
            return Int(mainView.contentOffset.x / self.bounds.width + 0.3)
        }
        return Int(mainView.contentOffset.y / self.bounds.height + 0.3)
        
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
        
        var index = indexPath.item
        switch index {
        case 0:
            index = totalCount - 1
        case totalCount + 1:
            index = 0
        default:
            index -= 1
        }
        
        guard cycleType != .custom else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId_Custom, for: indexPath)
            delegate?.setCustomCell?(cycleScrollView: self, customCell: cell, index: index)
            return cell
        }
        
        let bannerCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId_Image, for: indexPath) as! AABannerCell
        bannerCell.imageView.contentMode = self.bannerImageViewContentMode
        if imagesNameStringGroup.count > 0 {
            bannerCell.imageView.image = UIImage.init(named: imagesNameStringGroup[index])
        } else {
            bannerCell.imageView.kf.setImage(with: URL.init(string: imagesUrlStringGroup[index]), placeholder: placeHolderImage)
        }
        return bannerCell
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var index = indexPath.item
        switch index {
        case 0:
            index = totalCount - 1
        case totalCount + 1:
            index = 0
        default:
            index -= 1
        }
        delegate?.cycleScrollView?(self, didSelected: index)
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
        switch page {
        case 0:
            mainView.scrollToItem(at: IndexPath.init(item: totalCount, section: 0), at: position, animated: false)
            pageControl.currentPage = totalCount - 1
        case totalCount + 1:
            mainView.scrollToItem(at: IndexPath.init(item: 1, section: 0), at: position, animated: false)
            pageControl.currentPage = 0
        default:
            pageControl.currentPage = page - 1
        }
        self.delegate?.cycleScrollView?(self, scrollTo: pageControl.currentPage)
    }
    
}
