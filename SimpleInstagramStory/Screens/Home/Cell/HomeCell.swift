//
//  HomeCell.swift
//  SimpleInstagramStory
//
//  Created by Özgür Ersöz on 26.04.2020.
//  Copyright © 2020 Ozgur Ersoz. All rights reserved.
//

import Foundation
import UIKit

protocol HomeCellDisplayLogic: class {
    func showLoader()
    func hideLoader()
}

class HomeCell: UICollectionViewCell {

    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var profileImage: UIImageView!
    var viewModel: HomeCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func prepareView() {        
        profileImage.layer.cornerRadius = 40
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFill
        
        coverView.layer.cornerRadius = 40
        coverView.clipsToBounds = true
    }
}

extension HomeCell: HomeCellDisplayLogic {
    func showLoader() {
        DispatchQueue.main.async {
            self.coverView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            self.indicator.startAnimating()
            self.indicator.isHidden = false
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            self.coverView.backgroundColor = .clear
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
        }
    }
}
