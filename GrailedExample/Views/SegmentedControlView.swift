//
//  SegmentedControlView.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/16/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import UIKit

// MARK: - SegmentedControlViewDelegate
@objc protocol SegmentedControlViewDelegate: class {
    @objc optional func didSelectItem(at index: Int)
}

// MARK: - SegmentedControlView
final class SegmentedControlView: UIView {
    
    private let underlineView: UIView?
    private var underlineViewCenterXAnchor: NSLayoutConstraint?
    private var buttons: [UIButton] = []
    private var buttonStyles: [ButtonStyle] = []
    weak var delegate: SegmentedControlViewDelegate?
    
    init(frame: CGRect = .zero, underlineView: UIView? = nil) {
        self.underlineView = underlineView
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) { return nil }
    
}

// MARK: - Public Interface
extension SegmentedControlView {
    
    func configure(with styles: [ButtonStyle]) {
        subviews.forEach { $0.removeFromSuperview() }
        
        buttonStyles = styles
        buttons = createButtons(with: styles)
        
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.fillSuperview()
        
        guard let underlineView = underlineView,
              let firstButton = buttons.first else { return }
        
        addSubview(underlineView)
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.widthAnchor.constraint(equalTo: firstButton.widthAnchor, multiplier: 0.7).isActive = true
        underlineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        underlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        underlineViewCenterXAnchor = underlineView.centerXAnchor.constraint(equalTo: firstButton.centerXAnchor)
        underlineViewCenterXAnchor?.isActive = true
    }
    
    func selectItem(at index: Int) {
        guard buttons.count > index else { return }
        adjustButtonStyle(at: index)
        delegate?.didSelectItem?(at: index)
    }
    
}

// MARK: - Private Methods
extension SegmentedControlView {
    
    private func createButtons(with styles: [ButtonStyle]) -> [UIButton] {
        return styles.enumerated().map { offset, style in
            let button = UIButton()
            button.tag = offset
            button.set(style)
            button.addTarget(self, action: #selector(didSelectButton), for: .touchUpInside)
            return button
        }
    }
    
    @objc private func didSelectButton(_ sender: UIButton) {
        adjustButtonStyle(at: sender.tag)
        delegate?.didSelectItem?(at: sender.tag)
    }
    
    private func adjustButtonStyle(at index: Int) {
        buttons.forEach {
            $0.isSelected = index == $0.tag
            let imageColor = index == $0.tag ?
                buttonStyles[index].selectedTitleColor :
                buttonStyles[index].enabledTitleColor
            $0.imageView?.setImage(color: imageColor)
        }
        
        underlineViewCenterXAnchor?.constant = buttons[index].frame.origin.x
        UIView.animate(withDuration: 0.1, animations: {
           self.layoutIfNeeded()
        })
    }
    
}


