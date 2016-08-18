//
//  LZMLayer.swift
//  CALayerTest
//
//  Created by liuzhimin on 17/08/2016.
//  Copyright © 2016 liuzhimin. All rights reserved.
//

import UIKit

class LZMLayer: CATransformLayer {
    
    var color: UIColor = UIColor.white {
        didSet {
            guard let sublayers = sublayers , sublayers.count > 0 else { return }
            for (index, layer) in sublayers.enumerated() {
                (layer as? CAShapeLayer)?.fillColor = color.set(hueSaturationOrBrightness: .Brightness, percentage: 1.0-(0.1*CGFloat(index))).cgColor
            }
        }
    }
    
    /* 之后如果调整layer的大小，堆栈将会重新绘制.
     *
     * 假设长宽相等，圆角的半径被计算为宽度的四分之一
     * 默认大小是100X100
     */
    
    var size: CGSize = CGSize(width: 100, height: 100) {
        didSet {
            sublayers?.forEach({
                ($0 as? CAShapeLayer)?.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: size.width/4).cgPath
                ($0 as? CAShapeLayer)?.frame = (($0 as? CAShapeLayer)?.path)!.boundingBox
                setAnchorPoint(anchorPoint: CGPoint(x: 0.5, y: 0.5), forLayer: $0)
            })
        }
    }
    
    convenience init(withNumberOfItems items: Int) {
        self.init()
        masksToBounds = false
        
        /* 循环添加子图层 */
        
        for i in 0..<items {
            let layer = generateLayer(withSize: size, withIndex: i)
            insertSublayer(layer, at: 0)
            setZPosition(ofShape: layer, z: CGFloat(i))
        }
        
        /*为了颜色是自上而下变得更深*/
        
        sublayers = sublayers?.reversed()
        
        /*居中图层*/
        centerInSuperlayer()
        
        /*旋转自身图层3D z轴*/
        rotateParentLayer(toDegree : 60.0)
    }
    
    
    private func generateLayer(withSize size: CGSize, withIndex index: Int) -> CAShapeLayer {
        let square = CAShapeLayer()
        square.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: size.width/4).cgPath
        square.frame = square.path!.boundingBox
        /*设置中心点为描点 同时计算出新的位置*/
        setAnchorPoint(anchorPoint: CGPoint(x: 0.5, y: 0.5), forLayer: square)
        return square
    }
    
    // Because adjusting the anchorPoint itself adjusts the frame, this is needed to avoid it, and keep the layer stationary.
    
    private func setAnchorPoint(anchorPoint: CGPoint, forLayer layer: CALayer) {
        var newPoint = CGPoint(x: layer.bounds.size.width * anchorPoint.x, y: layer.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: layer.bounds.size.width * layer.anchorPoint.x, y: layer.bounds.size.height * layer.anchorPoint.y)
        newPoint = newPoint.applying(layer.affineTransform())
        oldPoint = oldPoint.applying(layer.affineTransform())
        
        var position = layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer.position = position
        layer.anchorPoint = anchorPoint
    }
    
    private func setZPosition(ofShape shape: CAShapeLayer, z: CGFloat) {
        shape.zPosition = z*(-20)
    }
    
    private func centerInSuperlayer() {
        frame = CGRect(x: getX(), y: getY(), width: size.width, height: size.height)
    }
    
    private func getX() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.size.width
        return (screenWidth/2)-(size.width/2)
    }
    
    private func getY() -> CGFloat {
        let screenHeight = UIScreen.main.bounds.size.height
        return (screenHeight/2)-(2*(size.height/2))
    }
    
    // When the time comes to animate, we'll need this. It converts...well...degrees into radians..
    
    private func degreesToRadians(degrees: CGFloat) -> CGFloat {
        return ((CGFloat(M_PI) * degrees) / 180.0)
    }
    
    private func rotateParentLayer(toDegree degree: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -500.0
        transform = CATransform3DRotate(transform, degree.degreesToRadians, 1, 0, 0)
        self.transform = transform
    }
}
