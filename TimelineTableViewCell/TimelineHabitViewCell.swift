//
//  TimelineHabitViewCell.swift
//  TimelineTableViewCell
//
//  Created by Terry Bui on 10/7/19.
//  Copyright © 2019 Zheng-Xiang Ke. All rights reserved.
//

import Foundation
import UIKit


open class TimelineHabitViewCell: UITableViewCell {
    
    @IBOutlet weak open var titleLabel: UILabel!
    
    @IBOutlet weak open var lineInfoLabel: UILabel!
    @IBOutlet weak open var thumbnailImageView: UIImageView!
    @IBOutlet weak open var illustrationImageView: UIImageView!
    @IBOutlet weak open var habitNameLabel: UILabel!
    @IBOutlet weak open var titleLabelLeftMargin: NSLayoutConstraint!
    
    @IBOutlet weak open var lineInfoLabelLeftMargin: NSLayoutConstraint!
    open var timelinePoint = TimelinePoint() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    open var timeline = Timeline() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    open var bubbleRadius: CGFloat = 2.0 {
        didSet {
            if (bubbleRadius < 0.0) {
                bubbleRadius = 0.0
            } else if (bubbleRadius > 6.0) {
                bubbleRadius = 6.0
            }
            
            self.setNeedsDisplay()
        }
    }
    
    open var bubbleColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override open func draw(_ rect: CGRect) {
        for layer in self.contentView.layer.sublayers! {
            if layer is CAShapeLayer {
                layer.removeFromSuperlayer()
            }
        }
        
        titleLabelLeftMargin.constant = timeline.leftMargin + 30
        titleLabel.sizeToFit()
        
        lineInfoLabelLeftMargin.constant = timeline.leftMargin - 55
        lineInfoLabel.sizeToFit()
        
        habitNameLabel.sizeToFit()
        
        timelinePoint.position = CGPoint(x: timeline.leftMargin + timeline.width / 2, y: titleLabel.frame.origin.y + titleLabel.intrinsicContentSize.height / 2 - timelinePoint.diameter / 2)
        
        timeline.start = CGPoint(x: timelinePoint.position.x + timelinePoint.diameter / 2, y: 0)
        timeline.middle = CGPoint(x: timeline.start.x, y: timelinePoint.position.y)
        timeline.end = CGPoint(x: timeline.start.x, y: self.bounds.size.height)
        timeline.draw(view: self.contentView)
        
        timelinePoint.draw(view: self.contentView)
        
        if let title = titleLabel.text, !title.isEmpty {
            drawBubble()
        }
    }
    
    fileprivate func drawBubble() {
        let offset: CGFloat = 16
        let bubbleRect = CGRect(
            x: timelinePoint.position.x + timelinePoint.diameter + timeline.width + offset,
            y: timelinePoint.position.y - timelinePoint.diameter - offset / 2,
            width: titleLabel.intrinsicContentSize.width + offset,
            height: titleLabel.intrinsicContentSize.height + offset)
        
        let path = UIBezierPath(roundedRect: bubbleRect, cornerRadius: bubbleRadius)
        let startPoint = CGPoint(x: bubbleRect.origin.x, y: bubbleRect.origin.y + bubbleRect.height / 2 - 8)
        path.move(to: startPoint)
        path.addLine(to: startPoint)
        path.addLine(to: CGPoint(x: bubbleRect.origin.x - 8, y: bubbleRect.origin.y + bubbleRect.height / 2))
        path.addLine(to: CGPoint(x: bubbleRect.origin.x, y: bubbleRect.origin.y + bubbleRect.height / 2 + 8))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = bubbleColor.cgColor
        
        self.contentView.layer.insertSublayer(shapeLayer, below: titleLabel.layer)
    }
}
