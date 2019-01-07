//
//  SegmentedPageViewController.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/17/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import UIKit

final class NavigationProperties {
    let navigationItem: UINavigationItem
    let hidesBarOnSwipe: Bool
    let preferredStatusBarStyle: UIStatusBarStyle
    let prefersStatusBarHidden: Bool
    
    init(navigationItem: UINavigationItem = UINavigationItem(),
         hidesBarOnSwipe: Bool = false,
         preferredStatusBarStyle: UIStatusBarStyle = .default,
         prefersStatusBarHidden: Bool = false) {
        self.navigationItem = navigationItem
        self.hidesBarOnSwipe = hidesBarOnSwipe
        self.preferredStatusBarStyle = preferredStatusBarStyle
        self.prefersStatusBarHidden = prefersStatusBarHidden
    }
}

class SegmentedPageViewController: UIPageViewController {
    
    enum Position {
        case top, bottom
    }
    
    // MARK: - Properties
    private let segmentedControlView: SegmentedControlView
    private let segmentedControlPosition: Position
    private let orderedViewControllers: [UIViewController]
    private let isAnimatedTransition: Bool
    private var navigationProperties: NavigationProperties
    private var currentIndex: Int = 0

    // MARK: - Initalization
    init(segmentedControlView: SegmentedControlView,
         segmentedControlPosition: Position,
         viewControllers: [UIViewController],
         isAnimatedTransition: Bool = true,
         navigationProperties: NavigationProperties = NavigationProperties()) {
        self.segmentedControlView = segmentedControlView
        self.segmentedControlPosition = segmentedControlPosition
        self.orderedViewControllers = viewControllers
        self.isAnimatedTransition = isAnimatedTransition
        self.navigationProperties = navigationProperties
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        setupSegmentedControlView()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    // MARK: - Status Bar Style
    override var prefersStatusBarHidden: Bool { return navigationProperties.prefersStatusBarHidden }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return navigationProperties.preferredStatusBarStyle
    }
    
    // MARK: - Navigation Item
    override var navigationItem: UINavigationItem {
        return navigationProperties.navigationItem
    }
    
    // MARK: - View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.reset(to: .white)
        segmentedControlView.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        segmentedControlView.isHidden = true
    }
    
}

// MARK: - SegmentedControlViewDelegarte
extension SegmentedPageViewController: SegmentedControlViewDelegate {
    
    func didSelectItem(at index: Int) {
        let direction: UIPageViewController.NavigationDirection = index > currentIndex ? .forward : .reverse
        setViewControllers([orderedViewControllers[index]],
                           direction: direction,
                           animated: isAnimatedTransition,
                           completion: { [weak self] _ in
                self?.currentIndex = index
        })
    }
    
}

// MARK: - Private Methods
extension SegmentedPageViewController {
    
    private func setupSegmentedControlView() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = segmentedControlView.backgroundColor
        view.addSubview(backgroundView)
        
        segmentedControlView.delegate = self
        segmentedControlView.selectItem(at: 0)
        
        view.addSubview(segmentedControlView)
        
        switch segmentedControlPosition {
        case .top:
            segmentedControlView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, heightConstant: 50)
            backgroundView.anchor(view.topAnchor, left: view.leftAnchor, bottom: segmentedControlView.bottomAnchor, right: view.rightAnchor)
        case .bottom:
            segmentedControlView.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, heightConstant: 50)
            backgroundView.anchor(segmentedControlView.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        }
    }
    
}


