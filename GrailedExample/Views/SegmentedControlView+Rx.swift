//
//  SegmentedControlView+Rx.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/17/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import RxSwift
import RxCocoa

extension SegmentedControlView: HasDelegate {
    public typealias Delegate = SegmentedControlViewDelegate
}

// MARK: Reactive Extension
extension Reactive where Base: SegmentedControlView {
    var delegate: DelegateProxy<SegmentedControlView, SegmentedControlViewDelegate> {
        return RxSegmentedControlViewDelegateProxy.proxy(for: base)
    }
    
    /// Bindable input to manually select index
    var selectIndex: Binder<Int> {
        return Binder(base) { segmentedControl, index in
            segmentedControl.selectItem(at: index)
        }
    }
    
    /// Observable output for selected index
    var selectedIndex$: Observable<Int> {
        return delegate.methodInvoked(#selector(SegmentedControlViewDelegate.didSelectItem(at:)))
            .map { $0[0] as? Int }
            .filterNil()
    }
}

// MARK: Delegate Proxy
private class RxSegmentedControlViewDelegateProxy:
    DelegateProxy<SegmentedControlView, SegmentedControlViewDelegate>,
    DelegateProxyType,
    SegmentedControlViewDelegate {
    
    init(segmentedControlView: ParentObject) {
        super.init(parentObject: segmentedControlView,
                   delegateProxy: RxSegmentedControlViewDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { RxSegmentedControlViewDelegateProxy(segmentedControlView: $0) }
    }
}

