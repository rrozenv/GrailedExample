import RxSwift
import RxCocoa

var str = "Hello, playground"

let disposeBag = DisposeBag()
let publishSubject = PublishSubject<Void>()
//
//let sequence = publishSubject.asObservable()
//    .subscribe(onNext: { _ in
//        print("Subscirbe!")
//    }, onError: {
//        print("Error: \($0)")
//    },
//       onCompleted: {
//        print("completed")
//    })
//    .disposed(by: disposeBag)
//
//let driver = publishSubject.asDriver(onErrorJustReturn: ())
//    .drive(onNext: {
//        print("next driver")
//    }, onCompleted: {
//        print("completed driver!")
//    }) {
//        print("disposed driver!")
//    }
//    .disposed(by: disposeBag)
//
//publishSubject.onNext(())
////publishSubject.onCompleted()
//publishSubject.onNext(())
//publishSubject.onNext(())

//func createObservable() {
//
//    let ints = Observable.of(1, 2, 3)
//    //let subject = PublishSubject<Int>()
//
//    ints.subscribe(onNext: {
//        print("next: \($0)")
//    }, onCompleted: {
//        print("completed")
//    }) {
//        print("Disposed")
//    }
//    .disposed(by: disposeBag)
//
//    //subject.onNext(1)
//
//}

//createObservable()

enum SavedSearchServiceMockError: Error {
    case networkError
}

class SavedSearchServiceMock {
    
    var shouldError = BehaviorRelay(value: false)
    
    func fetchAll() -> Observable<[String]> {
        //return .just(["First", "Second"])
        print("fetch all called")
//        let obs =
        return Observable<[String]>.create { observer in
            print("fetch all create called")
            switch self.shouldError.value {
            case true:
                observer.onError(SavedSearchServiceMockError.networkError)
            case false:
                let savedSearches = ["First", "Second"]
                observer.onNext(savedSearches)
            }
            observer.onCompleted()
            return Disposables.create()
        }
//        return Observable.deferred {
//            return obs
//        }
    }
    
    func createNew() -> Observable<Void> {
        return .empty()
    }
    
}

final class LoginViewModel {
    
    // MARK: - Input
    struct Input {
        let didTapLogin$: Observable<Void>
    }
    
    struct Output { }
    
    // MARK: - Initalization
    private let disposeBag = DisposeBag()
    
    // MARK: - Transformation
    func transform(input: Input) -> Output {
        let _network = SavedSearchServiceMock()
        //let shared =  input.didTapLogin$.share()
        //let saved = _network.fetchAll()
        _network.fetchAll()
            .subscribe(onNext: {
                print("on next login: \($0)")
            }, onCompleted: {
                print("completed login")
            }) {
                print("Disposed login")
            }
            .disposed(by: disposeBag)
        _network.fetchAll()
            .subscribe(onNext: {
                print("on next login: \($0)")
            }, onCompleted: {
                print("completed login")
            }) {
                print("Disposed login")
            }
            .disposed(by: disposeBag)
//        shared
//            .flatMap { _network.fetchAll() }
//            .subscribe(onNext: {
//                print("on next login: \($0)")
//            }, onCompleted: {
//                print("completed login")
//            }) {
//                print("Disposed login")
//            }
//            .disposed(by: disposeBag)
//
//        shared
//            .flatMap { _network.fetchAll() }
//            .subscribe(onNext: {
//                print("second login: \($0)")
//            }, onCompleted: {
//                print("second completed login")
//            }) {
//                print("second Disposed login")
//            }
//            .disposed(by: disposeBag)
        
//        input.didTapLogin$
//            .flatMap { _network.fetchAll() }
//            .subscribe(onNext: {
//                print("on next login: \($0)")
//            }, onCompleted: {
//                print("completed login")
//            }) {
//                print("Disposed login")
//            }
//            .disposed(by: disposeBag)
        
        return Output()
    }
    
}

let _didTapLogin = Observable.of((), ())
//PublishSubject<Void>()

let loginViewModel = LoginViewModel()

let inputs = LoginViewModel.Input(didTapLogin$: _didTapLogin.asObservable())

loginViewModel.transform(input: inputs)

//_didTapLogin.onNext(())
//_didTapLogin.onNext(())
