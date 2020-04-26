import UIKit

public struct CubeAttributesAnimator: LayoutAttributesAnimator {

    public var perspective: CGFloat
    
    public var totalAngle: CGFloat
    
    public init(perspective: CGFloat = -1 / 500, totalAngle: CGFloat = .pi / 3) {
        self.perspective = perspective
        self.totalAngle = totalAngle
    }
    
    public func animate(collectionView: UICollectionView, attributes: AnimatedCollectionViewLayoutAttributes) {
        let position = attributes.middleOffset
        if abs(position) >= 1 {
            attributes.contentView?.layer.transform = CATransform3DIdentity
            attributes.contentView?.keepCenterAndApplyAnchorPoint(CGPoint(x: 0.5, y: 0.5))
        } else if attributes.scrollDirection == .horizontal {
            let rotateAngle = totalAngle * position
            var transform = CATransform3DIdentity
            transform.m34 = perspective
            transform = CATransform3DRotate(transform, rotateAngle, 0, 1, 0)
            
            attributes.contentView?.layer.transform = transform
            attributes.contentView?.keepCenterAndApplyAnchorPoint(CGPoint(x: position > 0 ? 0 : 1, y: 0.5))
        }
    }
}
