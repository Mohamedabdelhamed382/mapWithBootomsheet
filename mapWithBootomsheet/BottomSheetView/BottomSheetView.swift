//
//  BottomSheetView.swift
//  mapWithBootomsheet
//
//  Created by Mohamed abdelhamed on 27/05/2024.
//

import UIKit

class BottomSheetView: UIView {
    
    var heightConstraint: NSLayoutConstraint!
    private var maxHeight: CGFloat = 0
    private var minHeight: CGFloat = 0
    weak var bottomSheetViewDelegate: BottomSheetViewProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 16
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        self.addGestureRecognizer(panGesture)
    }
    
    func configure(minHeightRatio: CGFloat, maxHeightRatio: CGFloat) {
        guard let superview = self.superview else { return }
        minHeight = superview.bounds.height * minHeightRatio
        maxHeight = superview.bounds.height * maxHeightRatio
        heightConstraint.constant = minHeight
    }
    
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        guard let superview = self.superview else { return }
        let translation = gesture.translation(in: superview)
        var newHeight = heightConstraint.constant - translation.y
        
        // Restrict the bottom sheet height to a minimum and maximum value
        newHeight = max(minHeight, newHeight)
        newHeight = min(maxHeight, newHeight)
        
        heightConstraint.constant = newHeight
        gesture.setTranslation(.zero, in: superview)
        
        if gesture.state == .ended {
            let midHeight = (minHeight + maxHeight) / 2
            let targetHeight = newHeight < midHeight ? minHeight : maxHeight
            UIView.animate(withDuration: 0.3) {
                self.heightConstraint.constant = targetHeight
                superview.layoutIfNeeded()
            }
            
            // Update the scroll view's scrolling behavior
            if let customView = self as? CustomView {
                customView.scrollView.isScrollEnabled = targetHeight == maxHeight
            }
        }
        
        bottomSheetViewDelegate?.bottomSheetPosition(position: heightConstraint.constant == maxHeight ? .top : .down)
    }
    
    func attach(to parentView: UIView, minHeightRatio: CGFloat, maxHeightRatio: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(self)
        
        heightConstraint = self.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
        ])
        
        configure(minHeightRatio: minHeightRatio, maxHeightRatio: maxHeightRatio)
    }
}

enum BottomSheetPosition {
    case top
    case down
}

protocol BottomSheetViewProtocol: AnyObject {
    func bottomSheetPosition(position: BottomSheetPosition)
}
