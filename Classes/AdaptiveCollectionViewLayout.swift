//
//  AdaptiveCollectionViewLayout.swift
//  UrpayCards
//
//  Created by Ahmed Wahdan on 30/09/2024.
//

import UIKit

class AdaptiveCollectionViewLayout: UICollectionViewFlowLayout {
    
    enum LayoutType {
        case linear
        case overlap
    }
    
    var layoutType: LayoutType = .linear
    let itemScaleFactor: CGFloat = 0.75
    let overlapFactor: CGFloat = 50 // The overlap amount for the overlap layout
    
    override init() {
        super.init()
        scrollDirection = .horizontal
        minimumLineSpacing = 10 // Default for linear layout, can be overridden
        itemSize = CGSize(width: 200, height: 250) // Example item size
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // This method is called when the collection view’s bounds change
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    // Adjust the layout attributes to create the desired effect
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect)?.map({ $0.copy() as! UICollectionViewLayoutAttributes }) else {
            return nil
        }
        
        let visibleRect = CGRect(origin: collectionView!.contentOffset, size: collectionView!.bounds.size)
        let centerX = visibleRect.midX
        
        for attribute in attributes {
            let distanceFromCenter = abs(attribute.center.x - centerX)
            let scale = max(1 - (distanceFromCenter / collectionView!.bounds.width), itemScaleFactor)
            
            switch layoutType {
            case .linear:
                // Linear scaling
                attribute.transform = CGAffineTransform(scaleX: scale, y: scale)
                minimumLineSpacing = 10 // Adjust to your needs

            case .overlap:
                // Overlap scaling with zIndex adjustment
                attribute.transform = CGAffineTransform(scaleX: scale, y: scale)
                attribute.zIndex = Int(-distanceFromCenter)
                
                // Shift the position to create the overlap effect
                let overlapOffset = (distanceFromCenter / collectionView!.bounds.width) * overlapFactor
                attribute.center.x += overlapOffset
                minimumLineSpacing = -overlapFactor // Overlap effect between items
            }
        }
        
        return attributes
    }
    
    // Custom paging behavior to align items in the center
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }
        
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.width, height: collectionView.bounds.height)
        guard let attributes = layoutAttributesForElements(in: targetRect) else { return proposedContentOffset }
        
        let horizontalCenter = proposedContentOffset.x + collectionView.bounds.width / 2
        let closestAttribute = attributes.min(by: { abs($0.center.x - horizontalCenter) < abs($1.center.x - horizontalCenter) }) ?? UICollectionViewLayoutAttributes()
        
        let offsetAdjustment = closestAttribute.center.x - horizontalCenter
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}

/*
 //MARK: - Usage
 let layout = AdaptiveCollectionViewLayout()
 layout.layoutType = .linear // or .overlap based on your desired effect

 let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

 */
