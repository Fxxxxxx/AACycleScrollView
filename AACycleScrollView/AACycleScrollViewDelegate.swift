//
//  AACycleScrollViewDelegate.swift
//  uchain
//
//  Created by Fxxx on 2018/11/19.
//  Copyright © 2018 Fxxx. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol AACycleScrollViewDelegate {
    //点击回调
    @objc optional func cycleScrollView(_: AACycleScrollView, didSelected index: Int)
    //当前展示的序号
    @objc optional func cycleScrollView(_: AACycleScrollView, scrollTo index: Int)
    
    //使用自定义的cell  class or nib
    @objc optional func customCellClassFor(cycleScrollView: AACycleScrollView) -> UICollectionViewCell.Type
    @objc optional func customCellNibFor(cycleScrollView: AACycleScrollView) -> UINib
    //设置自定义的cell
    @objc optional func setCustomCell(cycleScrollView: AACycleScrollView, customCell: UICollectionViewCell, index: Int)
}
