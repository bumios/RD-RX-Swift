//
//  HomeViewController.swift
//  RD-RX-Swift
//
//  Created by Duy Tran N. VN.Danang on 3/24/22.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {

    @IBOutlet private weak var myTextField: UITextField!

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
//        runObservable()
//        runPublishSubject()
//        runBehaviourSubject()

    ()
    }
}

extension HomeViewController {

    // MARK: - Observable
    private func runObservable() {
        let disposeBag = DisposeBag()

        // Khởi tạo một Observable
        let observable = Observable.from(["☘️", "🍀", "🧨", "🔥"])
        observable
            // Thực hiện việc đăng ký lắng nghe thay đổi của Observable
            .subscribe(
                onNext: { data in
                    // Nơi Observer nhận dữ liệu được phát ra
                    print(data)
                },
                onError: { error in
                    // Nơi Observer nhận error và Observable được giải phóng
                    print(error)
                },
                onCompleted: {
                    // Nơi nhận sự kiện Observable hoàn thành và Observable được giải phóng
                    print("Completed")
                }
            )
            .disposed(by: disposeBag)
    }

    // MARK: - Subjects
    private func runPublishSubject() {
        let subject: PublishSubject<String> = PublishSubject()

        subject.onNext("one")

        subject
            .subscribe(onNext: { value in
                print(value)
            })
            .disposed(by: disposeBag)


        subject.onNext("two")
        subject.onNext("three")
    }

    private func runBehaviourSubject() {
        let subject: BehaviorSubject<String> = BehaviorSubject(value: "default-value")

        subject.onNext("one")

        subject
            .subscribe(onNext: { value in
                print(value)
            })
            .disposed(by: disposeBag)


        subject.onNext("two")
        subject.onNext("three")
    }

    private func runReplaySubject() {
        let subject = ReplaySubject<String>.create(bufferSize: 2)

        subject.onNext("one")
        subject.onNext("two")
        subject.onNext("three")

        subject
            .subscribe(onNext: { value in
                print(value)
            })
            .disposed(by: disposeBag)


        subject.onNext("four")
        subject.onNext("five")
    }
}

enum MyRxError: Error {
    case common
}
