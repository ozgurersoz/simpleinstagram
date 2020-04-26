//
//  HomeViewContoller.swift
//  SimpleInstagramStory
//
//  Created by Özgür Ersöz on 26.04.2020.
//  Copyright © 2020 Ozgur Ersoz. All rights reserved.
//

import Foundation
import UIKit

protocol HomeViewControllerDisplayLogic: class {}

class HomeViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    private var viewModel: HomeViewModelLogic?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
        print("nib")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        print("required")
    }
    
    func setup() {
        let viewModel = HomeViewModel(viewController: self)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.loadData()
        collectionView.showsHorizontalScrollIndicator = false
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.stories.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as? HomeCell
        
        guard let homeCell = cell, let story = viewModel?.stories[indexPath.row] else {
            return UICollectionViewCell()
        }
        
        let cellViewModel = HomeCellViewModel(story: story, cell: homeCell)
        homeCell.viewModel = cellViewModel
        homeCell.profileImage.image = UIImage(named: story.profilePhotoId)
        return homeCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = Storyboard.Main.view(controllerClass: StoriesCollectionViewController.self)
        vc.viewModel = StoriesViewModel(viewController: vc, selectedIndex: indexPath.row)
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)

        let item = collectionView.cellForItem(at: indexPath) as? HomeCell
        item?.hideLoader()
    }
}

extension HomeViewController: HomeViewControllerDisplayLogic {}
