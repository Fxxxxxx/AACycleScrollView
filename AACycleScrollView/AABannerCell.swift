//
//  AABannerCell.swift
//  uchain
//
//  Created by Fxxx on 2018/11/19.
//  Copyright © 2018 Fxxx. All rights reserved.
//

import UIKit

class AABannerCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    static func nib() -> UINib {
        let bundle = Bundle.init(for: classForCoder())
        return UINib.init(nibName: .init(describing: classForCoder()), bundle: bundle)
    }
    
}
