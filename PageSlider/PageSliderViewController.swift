//
//  PageSliderViewController.swift
//  PageSlider
//
//  Created by Oleksandr Glagoliev on 10/19/17.
//  Copyright © 2017 Oleksandr Glagoliev. All rights reserved.
//

import UIKit

class PageSliderViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Costants
    fileprivate let minPageSwitchingOffset: CGFloat = 40
    
    // Variables
    fileprivate var currentPage: Int = 0
    fileprivate var startOffset = CGPoint.zero
    fileprivate var finishOffset = CGPoint.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibs()
    }
    
    private func registerNibs() {
        let containerCellNib = UINib(nibName: "ContainerCell", bundle:nil)
        collectionView.register(containerCellNib, forCellWithReuseIdentifier: "ReuseId.Cell.container")
    }
    
    // Helpers
    fileprivate func scrollToSlide(slide: Int) {
        collectionView.scrollToItem(at: IndexPath(row: slide, section: 0), at: UICollectionViewScrollPosition.left, animated: true)
    }
}

extension PageSliderViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReuseId.Cell.container", for: indexPath) as! ContainerCell
        return cell
    }
}

extension PageSliderViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension PageSliderViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffset = collectionView.contentOffset
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        finishOffset = collectionView.contentOffset
        if decelerate {
           collectionView.setContentOffset(finishOffset, animated: false)
        }
        let diffX = finishOffset.x - startOffset.x
        if abs(diffX) > minPageSwitchingOffset {
            currentPage += (diffX > 0) ? 1 : -1
        }
        // restrictions to avoid `OutOfRange` error
        currentPage = min(max(0, currentPage), collectionView.numberOfItems(inSection: 0) - 1)
        scrollToSlide(slide: currentPage)
    }
}
