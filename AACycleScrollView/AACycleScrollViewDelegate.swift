//
//  AACycleScrollViewDelegate.swift
//  uchain
//
//  Created by Fxxx on 2018/11/19.
//  Copyright © 2018 Fxxx. All rights reserved.
//

import Foundation

@objc public protocol AACycleScrollViewDelegate {
    
    @objc optional func cycleScrollView(_: AACycleScrollView, didSelected: Int) -> Void
    
}
