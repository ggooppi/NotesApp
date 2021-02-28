//
//  NotesLayout.swift
//  Notes
//
//  Created by Gopinath.A on 27/02/21.
//

import UIKit

protocol NotesLayoutDelegate: AnyObject {
    func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
    
    func collectionView(
        _ collectionView: UICollectionView,
        hasImageURL indexPath: IndexPath) -> Bool
    
}

class NotesLayout: UICollectionViewLayout {
    // 1
    weak var delegate: NotesLayoutDelegate?
    
    // 2
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 6
    
    // 3
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    // 4
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    // 5
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        // 1
        guard
            let collectionView = collectionView
        else {
            return
        }
        // 2
        var columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
//        for column in 0..<numberOfColumns {
//            xOffset.append(CGFloat(column) * columnWidth)
//        }
        var column = 0
        
        
        // 3
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            // 4
            let photoHeight = delegate?.collectionView(
                collectionView,
                heightForPhotoAtIndexPath: indexPath) ?? 180
            let height = cellPadding * 2 + photoHeight
            
            let hasURL = delegate?.collectionView(collectionView, hasImageURL: indexPath) ?? false
            let previousHasURL = delegate?.collectionView(collectionView, hasImageURL: IndexPath(item: item - 1, section: 0)) ?? false
            
            if hasURL{
                columnWidth = contentWidth
                xOffset[column] = 0
                yOffset[column] = yOffset.max()!
                if column < (numberOfColumns - 1){
                    xOffset[column + 1] = 0
                    yOffset[column + 1] =  yOffset[column] + height
                }else{
                    xOffset[0] = 0
                    yOffset[0] = yOffset[column] + height
                }
            }else{
                columnWidth = contentWidth / CGFloat(numberOfColumns)
                if column == 0 {
                    if xOffset[numberOfColumns - 1] == 0 && item != 0 && !previousHasURL{
                        xOffset[column] = contentWidth / CGFloat(numberOfColumns)
                    }else{
                        xOffset[column] = 0
                    }
                }else{
                    if item != 0{
                        
                        if previousHasURL{
                            xOffset[column] = 0
                        }else if xOffset[column - 1] != 0{
                            xOffset[column] = 0
                        }else{
                            xOffset[column] = CGFloat(column) * columnWidth
                        }
                    }else{
                        xOffset[column] = CGFloat(column) * columnWidth
                    }
                    
                   
//                    if xOffset[column - 1] == 0 && yOffset[column - 1] == height{
//                        xOffset[column] = contentWidth / CGFloat(numberOfColumns)
//                    }else{
//                        xOffset[column] = 0
//                    }
                    
                }
            }
            
            print("\(item + 1)) (\(xOffset[column]), \(yOffset[column])), height: \(height)")
            
            let frame = CGRect(x: xOffset[column],
                               y: yOffset[column],
                               width: columnWidth,
                               height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // 5
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            // 6
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect)
    -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath)
    -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
