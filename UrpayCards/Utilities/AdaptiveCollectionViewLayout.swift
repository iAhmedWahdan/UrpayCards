//
//  AdaptiveCollectionViewLayout.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 30/09/2024.
//

import UIKit

class AdaptiveCollectionViewLayout: UICollectionViewFlowLayout {

    var itemScaleFactor: CGFloat = 0.75
    var overlapFactor: CGFloat = 50 // Adjust for the overlap effect

    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        // Automatically calculate the section insets based on item size
        let sideInset = (collectionView.bounds.size.width - itemSize.width) / 2
        sectionInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
        
        // Set other necessary properties (spacing, scroll direction)
        scrollDirection = .horizontal
        minimumLineSpacing = -overlapFactor // Overlap between items
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    // Adjust the layout attributes for visible items to create scaling and overlap effect
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributesArray = super.layoutAttributesForElements(in: rect) else { return nil }
        guard let collectionView = collectionView else { return attributesArray }

        let centerX = collectionView.contentOffset.x + collectionView.bounds.size.width / 2

        for attributes in attributesArray {
            let distanceFromCenter = abs(attributes.center.x - centerX)
            let scale = max(1 - (distanceFromCenter / collectionView.bounds.size.width), itemScaleFactor)
            attributes.transform = CGAffineTransform(scaleX: scale, y: scale)

            // Adjust zIndex for overlapping effect
            attributes.zIndex = Int(-distanceFromCenter)
        }
        return attributesArray
    }

    // Ensure smooth centering on scrolling
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }

        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.width, height: collectionView.bounds.height)
        guard let attributesArray = layoutAttributesForElements(in: targetRect) else { return proposedContentOffset }

        let centerX = proposedContentOffset.x + collectionView.bounds.size.width / 2

        var minDistance = CGFloat.greatestFiniteMagnitude

        for attributes in attributesArray {
            let distance = attributes.center.x - centerX
            if abs(distance) < abs(minDistance) {
                minDistance = distance
            }
        }

        let adjustedOffset = CGPoint(x: proposedContentOffset.x + minDistance, y: proposedContentOffset.y)
        return adjustedOffset
    }
}

/*
 //MARK: - Usage
 let layout = AdaptiveCollectionViewLayout()
 layout.layoutType = .linear // or .overlap based on your desired effect

 let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

 */
