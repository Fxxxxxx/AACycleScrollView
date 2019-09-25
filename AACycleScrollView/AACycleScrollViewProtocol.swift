//
//  AACycleScrollViewProtocol.swift
//  Test
//
//  Created by Fxxx on 2019/8/10.
//  Copyright © 2019 AaronFeng. All rights reserved.
//

import Foundation
import UIKit

public protocol AACycleScrollViewDataSource: AnyObject {
    //需要展示的项目数量
    func numbersOfItems(_ cycleView: AACycleScrollView) -> Int
    //序号为index的展示图片（可选）
    func imageForItem(in index: Int, with cycleView: AACycleScrollView) -> UIImage?
    //序号为index的图片链接（可选）
    func imageUrlStringForItem(in index: Int, with cycleView: AACycleScrollView) -> String?
    //自定义的显示样式 （可选，设置此项后，上面返回的图片和图片链接将无效）
    func customCellNib(_ cycleView: AACycleScrollView) -> UINib?
    func customCellClass(_ cycleView: AACycleScrollView) -> UICollectionViewCell.Type?
    //设置自定义cell的样式和数据
    func setCustomCell(_ cell: UICollectionViewCell, in index: Int, with cycleView: AACycleScrollView)
}

public extension AACycleScrollViewDataSource {
    func numbersOfItems(_ cycleView: AACycleScrollView) -> Int {
        return 0
    }
    func imageForItem(in index: Int, with cycleView: AACycleScrollView) -> UIImage? {
        return nil
    }
    func imageUrlStringForItem(in index: Int, with cycleView: AACycleScrollView) -> String? {
        return nil
    }
    func customCellNib(_ cycleView: AACycleScrollView) -> UINib? {
        return nil
    }
    func customCellClass(_ cycleView: AACycleScrollView) -> UICollectionViewCell.Type? {
        return nil
    }
    func setCustomCell(_ cell: UICollectionViewCell, in index: Int, with cycleView: AACycleScrollView) {}
}

public protocol AACycleScrollViewDelegate: AnyObject {
    //点击回调
    func cycleScrollView(_: AACycleScrollView, didSelected index: Int)
    //当前展示的序号
    func cycleScrollView(_: AACycleScrollView, scrollTo index: Int)
}

public extension AACycleScrollViewDelegate {
    func cycleScrollView(_: AACycleScrollView, didSelected index: Int) {}
    func cycleScrollView(_: AACycleScrollView, scrollTo index: Int) {}
}
