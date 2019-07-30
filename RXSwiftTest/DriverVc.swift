

//
//  DriverVc.swift
//  RXSwiftTest
//
//  Created by Andy on 2019/7/30.
//  Copyright © 2019 wangyawei. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DriverVc: UIViewController {

    @IBOutlet weak var textLabel: UILabel!

    @IBOutlet weak var textField: UITextField!

    @IBOutlet weak var btn: UIButton!

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 现在我们要实现一个绑定 在Rx的世界里面很简单
        // throttle:指定了0.5，所以在0.5以内，只接收了第一条和最新的数据。
        // 在主线程中操作，0.3秒内值若多次改变，取最后一次


        demo2()
    }


    // 普通做法
    func demo1() {
        let result = textField.rx.text
            .flatMap {[weak self] (inputText) -> Observable<Any> in
                return (self?.dealWithData(inputText: inputText ?? ""))!
                .observeOn(MainScheduler())
                    .catchErrorJustReturn("检测到了错误事件")
        }.share(replay: 1, scope: .whileConnected)

    }


    // 升级做法：Driver
    func demo2() {
        let result = textField.rx.text.orEmpty
            .asDriver()
            .flatMap {
                return self.dealWithData(inputText: $0)
                .asDriver(onErrorJustReturn: "检测到了错误事件")
        }

        // 请求一次网络
        // 绑定到了UI - 主线程
        // titlt - 非error
        result.map { "长度: \(($0 as! String).count)"}.drive(self.textLabel.rx.text)

        result.map { "\($0 as! String)"}
            .drive(self.btn.rx.title())
    }



    /// 模拟网络请求
    func dealWithData(inputText: String) -> Observable<Any> {

        print("请求网络了\(Thread.current)")

        return Observable<Any>.create({ (observer) -> Disposable in

            if inputText == "1234" {
                observer.onError(NSError.init(domain: "com.sina.www", code: 10010, userInfo: nil))
            }
            DispatchQueue.global().async {
                print("发送之前看看: \(Thread.current)")

                observer.onNext("已经输入:\(inputText)")
                observer.onCompleted()
            }
            return Disposables.create()
        })

    }


}
