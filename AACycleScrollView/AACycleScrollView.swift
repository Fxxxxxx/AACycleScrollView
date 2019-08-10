//
//  AACycleScrollView.swift
//  Test
//
//  Created by Fxxx on 2019/8/10.
//  Copyright © 2019 AaronFeng. All rights reserved.
//

import UIKit
import Kingfisher

public class AACycleScrollView: UIView {
    
    public weak var delegate: AACycleScrollViewDelegate?
    public weak var dataSource: AACycleScrollViewDataSource? {
        didSet {
            registerCell()
        }
    }
    
    private var CELLID = ""
    public var mainView: UICollectionView!
    public let layout = UICollectionViewFlowLayout()
    private var timer: Timer?
    private var totalCount = 0
    //此版本的UIPageControl完全开放出来由用户自行调节，可以使用约束或者frame随意调节位置，可以随意自行设置属性， 默认放在下方居中显示
    public let pageControl = UIPageControl()
    
    public var bannerImageViewContentMode = ContentMode.scaleAspectFill
    public var placeHolderImage: UIImage?
    public var autoScrollTimeInterval: TimeInterval = 2.0
    private var position = UICollectionView.ScrollPosition.left
    public var scrollDirection = UICollectionView.ScrollDirection.horizontal {
        didSet {
            layout.scrollDirection = scrollDirection
            position = scrollDirection == .horizontal ? .left : .top
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mainView = UICollectionView.init(frame: frame, collectionViewLayout: layout)
        mainView.backgroundColor = .white
        self.addSubview(mainView)
        mainView.dataSource = self
        mainView.delegate = self
        mainView.isPagingEnabled = true
        mainView.showsVerticalScrollIndicator = false
        mainView.showsHorizontalScrollIndicator = false
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        pageControl.frame = .init(x: 0, y: frame.height - 30, width: frame.width, height: 30)
        self.addSubview(pageControl)
        
        NotificationCenter.default.addObserver(self, selector: #selector(invalidateTimer), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setTimer), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func didMoveToSuperview() {
        reload()
    }
    
    public override func layoutSubviews() {
        mainView.frame = self.bounds
        layout.itemSize = self.bounds.size
        pageControl.frame = .init(x: 0, y: frame.height - 30, width: frame.width, height: 30)
    }
    
    public override func removeFromSuperview() {
        invalidateTimer()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public func reload() {
        totalCount = dataSource?.numbersOfItems(self) ?? 0
        mainView.reloadData()
        pageControl.numberOfPages = totalCount
        pageControl.isHidden = totalCount < 2
        if totalCount > 1 {
            scrollViewDidEndScrollingAnimation(mainView)
            setTimer()
        } else {
            invalidateTimer()
        }
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
        guard bounds != .zero else {
            return 0
        }
        if scrollDirection == .horizontal {
            return Int(mainView.contentOffset.x / bounds.width + 0.3)
        }
        return Int(mainView.contentOffset.y / bounds.height + 0.3)
    }
    
    @objc func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func setTimer() {
        invalidateTimer()
        timer = Timer.scheduledTimer(timeInterval: autoScrollTimeInterval, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
    }
    
    private func registerCell() {
        guard let ds = dataSource else { return }
        CELLID = "custom"
        if let nib = ds.customCellNib(self) {
            mainView.register(nib, forCellWithReuseIdentifier: CELLID)
            reload()
            return
        }
        if let c = ds.customCellClass(self) {
            mainView.register(c, forCellWithReuseIdentifier: CELLID)
            reload()
            return
        }
        CELLID = "banner"
        mainView.register(AABannerCell.nib(), forCellWithReuseIdentifier: CELLID)
        reload()
    }
    
}

extension AACycleScrollView: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalCount > 1 ? totalCount + 2 : totalCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var index = indexPath.item - 1
        if indexPath.item == 0 {
            index = totalCount - 1
        } else if indexPath.item == totalCount + 1 {
            index = 0
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELLID, for: indexPath)
        if CELLID == "custom" {
            dataSource?.setCustomCell(cell, in: index, with: self)
        } else {
            guard let bannerCell = cell as? AABannerCell else { return cell }
            bannerCell.imageView.contentMode = bannerImageViewContentMode
            if let url = dataSource?.imageUrlStringForItem(in: index, with: self) {
                bannerCell.imageView.kf.setImage(with: URL.init(string: url), placeholder: placeHolderImage)
            } else {
                bannerCell.imageView.image = dataSource?.imageForItem(in: index, with: self)
            }
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var index = indexPath.item - 1
        if indexPath.item == 0 {
            index = totalCount - 1
        } else if indexPath.item == totalCount + 1 {
            index = 0
        }
        delegate?.cycleScrollView(self, didSelected: index)
    }
    
}

extension AACycleScrollView: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        invalidateTimer()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        setTimer()
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(scrollView)
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
        delegate?.cycleScrollView(self, scrollTo: pageControl.currentPage)
    }
}
