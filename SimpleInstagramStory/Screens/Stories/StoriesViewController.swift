////
////  StoriesViewController.swift
////  SimpleInstagramStory
////
////  Created by Özgür Ersöz on 22.04.2020.
////  Copyright © 2020 Ozgur Ersoz. All rights reserved.
////

import UIKit

protocol StoryDelegate: class {
    func nextStory(nextStoryIndex: Int, previousStory: StoryCollectionViewCellDisplayLogic)
    func dismissStories()
    func drag(to point: CGPoint)
    func setCollectionViewScrollableStatus(_ status: Bool)
}

class StoriesCollectionViewController: UIViewController {
    var viewModel: StoriesViewModelLogic?
    
    @IBOutlet weak var collectionView: UICollectionView!
    convenience init(viewModel: StoriesViewModelLogic) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        collectionView?.isPagingEnabled = true
        if let layout = collectionView.collectionViewLayout as? AnimatedCollectionViewLayout {
            layout.scrollDirection = .horizontal
            layout.animator = CubeAttributesAnimator()
            layout.sectionInsetReference = .fromSafeArea
        }
        collectionView.showsHorizontalScrollIndicator = false        
     }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension StoriesCollectionViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource  {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.stories.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoryCollectionViewCell", for: indexPath)
        guard let storyCell = cell as? StoryCollectionViewCell, let story = viewModel?.stories[indexPath.row] else {
            return UICollectionViewCell()
        }
        let cellViewModel = StoryCollectionViewCellViewModel(cell: storyCell, story: story, owner: self, index: indexPath.row)
        storyCell.viewModel = cellViewModel        
        storyCell.contentView.clipsToBounds = true
        return storyCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let item = cell as? StoryCollectionViewCellDisplayLogic else { return }
        item.stopVideo()
        item.dismissStory()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.layoutFrame.size
        } else {
            return view.frame.size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func presentSelectedStory(at index: Int) {
    // TODO: burada bir sorun var
//        let offset = view.frame.width * CGFloat(index)
//        collectionView.moveToFrame(contentOffset: offset)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            self.collectionView.alpha = 1
//        }
    }
}

extension StoriesCollectionViewController: StoriesViewControllerDisplayLogic {
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension StoriesCollectionViewController: StoryDelegate {
    func nextStory(nextStoryIndex: Int, previousStory: StoryCollectionViewCellDisplayLogic) {
        collectionView.scrollToNextItem { (isLastStory) in
            if isLastStory {
                guard let nextStory = collectionView.cellForItem(at: IndexPath(row: nextStoryIndex-1, section: 0)) as? StoryCollectionViewCell else { return }
                nextStory.dismissStory()
                self.dismiss()
            }
        }
    }
    
    func dismissStories() {
        self.dismiss()
    }
    
    func drag(to point: CGPoint) {
        UIView.animate(withDuration: 0.2) {
            self.view.frame.origin = point
        }
    }
    
    func setCollectionViewScrollableStatus(_ status: Bool) {
        self.collectionView.isScrollEnabled = status
    }
}

extension UICollectionView {
    func scrollToNextItem(isEndOfContent handler: (Bool) -> Void) {
        let contentOffset = CGFloat(floor(self.contentOffset.x + self.bounds.size.width))
        guard contentOffset <= self.contentSize.width - self.bounds.size.width else {
            handler(true)
            return
        }
        handler(false)
        self.moveToFrame(contentOffset: contentOffset)
    }

    func scrollToPreviousItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x - self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }

    func moveToFrame(contentOffset : CGFloat) {
        self.setContentOffset(CGPoint(x: contentOffset, y: self.contentOffset.y), animated: true)
    }
}
