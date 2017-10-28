//
//  PageSliderViewController.swift
//  PageSlider
//
//  Created by Oleksandr Glagoliev on 10/19/17.
//  Copyright © 2017 Oleksandr Glagoliev. All rights reserved.
//

import UIKit

//enum SupplementaryViewKind: String {
//}

struct ReuseId {
    enum Cell: String {
        case card = "CardCellReuseId"
    }
//    enum SupplementaryView: String {
//    }
}

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
        setupAppearance()
        registerNibs()
    }
    
    private func setupAppearance() {
        collectionView.decelerationRate = 0.1
        collectionView.backgroundColor = UIColor.gray
    }
    
    private func registerNibs() {
        let containerCellNib = UINib(nibName: "ContainerCell", bundle:nil)
        collectionView.register(containerCellNib, forCellWithReuseIdentifier: ReuseId.Cell.card.rawValue)
    }
}

extension PageSliderViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseId.Cell.card.rawValue, for: indexPath) as! ContainerCell
        return cell
    }
}

extension PageSliderViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension PageSliderViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffset = collectionView.contentOffset
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        finishOffset = collectionView.contentOffset
        
        let diffX = finishOffset.x - startOffset.x
        if abs(diffX) > minPageSwitchingOffset {
            currentPage += (diffX > 0) ? 1 : -1
        }
        
        // restrictions to avoid `OutOfRange` error
        currentPage = min(max(0, currentPage), collectionView.numberOfItems(inSection: 0) - 1)
        
        let w: CGFloat = collectionView.bounds.width - PageSliderLayout.Config.inactiveCellVisibleAreaWidth * 2 - PageSliderLayout.Config.horizontalSpace * 2
        let x: CGFloat = CGFloat(currentPage) * (w + PageSliderLayout.Config.horizontalSpace )
        targetContentOffset.pointee = CGPoint(x: x, y: 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    
}
