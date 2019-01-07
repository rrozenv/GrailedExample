//
//  BaseCoordinator.swift
//  GrailedExample
//
//  Created by Robert Rozenvasser on 12/5/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import RxSwift
import Foundation

public class BaseCoordinator<ResultType> {
    typealias CoordinationResult = ResultType
    
    let disposeBag = DisposeBag()
    let identifier = UUID()
    private var childCoordinators = [UUID: Any]()
    private func store<T>(coordinator: BaseCoordinator<T>) {
        print("storing coor: \(coordinator.identifier)")
        childCoordinators[coordinator.identifier] = coordinator
    }

    private func free<T>(coordinator: BaseCoordinator<T>) {
        print("freeing coor: \(coordinator.identifier)")
        childCoordinators[coordinator.identifier] = nil
    }
    
    @discardableResult
    public func coordinate<T>(to coordinator: BaseCoordinator<T>) -> Observable<T> {
        store(coordinator: coordinator)
        return coordinator.start()
            .do(onNext: { [weak self] _ in
                self?.free(coordinator: coordinator)
            })
    }
    
    @discardableResult
    public func start() -> Observable<ResultType> {
        fatalError("Start method should be implemented.")
    }
}
