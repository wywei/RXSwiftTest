//
//  ViewController.swift
//  RXSwiftTest
//
//  Created by Andy on 2018/1/23.
//  Copyright © 2018年 wangyawei. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    let disposeBag = DisposeBag()

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var pwdLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var pwdTf: UITextField!
    @IBOutlet weak var userNameTf: UITextField!
    let userNameMinCount = 6
    let passwordMinCount = 10


    var person = Person(name: "")
    let btn = UIButton()
    let tf = UITextField()
    let scrollView = UIScrollView()
    var timer: Observable<Int>!
    var label = UILabel()

    var gcdtimer:DispatchSourceTimer?

 

    override func viewDidLoad() {
        super.viewDidLoad()

        // FRP-
        // 可观察序列
        // 无限  - 又穷

        /*
        let ob = Observable.just([1,2,3,4])
        ob.subscribe(onNext: { (num) in
            print(num)
        }, onCompleted: {
            print("订阅完成")
        })

        URLSession.shared.rx.response(request: URLRequest.init(url: URL(string: "")!))
            .subscribe(onNext: { (res, data) in

            }, onError: { (error) in

                print("error\(error)")
            }, onCompleted: {

            })*/


        // let ob = AnonymousObservable

        /*
        // 1、创建序列
        let ob = Observable<Any>.create { (observer) -> Disposable in
            // 3、发送信号
            observer.onNext("发送信号")
            // 2取1
            observer.onCompleted()

            observer.onError(NSError.init(domain: "andy", code: 1006, userInfo: nil))

            return Disposables.create()
        }

        /*
        Observable<Any>.create { (obser) -> Disposable in
            // 这个闭包什么时候调用的呢？

            return Disposables.create()
        }*/

        // 2、订阅信号
        let _ = ob.subscribe(onNext: { (text) in
            print("text",text)
        }, onError: { (error) in
            print("error",error)
        }, onCompleted: {
            print("订阅到完成")
        }) {
            print("销毁")
        }*/


        // RxSwiftDemo
       // setupLogin()


        // timer
        //testTimer()


    }



//    func dealWithData(imputText: String) -> Observable<Any>
//    {
//
//        return Disposables.create()
//    }


    func array() {
        let arr = ["123","234"]


    }

    /// GCD timer
    func testTimer() {
        gcdtimer = DispatchSource.makeTimerSource()
        gcdtimer?.schedule(deadline: DispatchTime.now(), repeating: 1)
        gcdtimer?.setEventHandler(handler: {
            print("=====")
        })
        gcdtimer?.resume()
    }


    /// RxSwiftDemo
    func setupLogin() {
        let usernameVaild = userNameTf.rx.text.orEmpty.map { (text) in
            return text.count > self.userNameMinCount
        }

        usernameVaild.bind(to: userNameLabel.rx.isHidden).disposed(by: disposeBag)
        usernameVaild.bind(to: pwdTf.rx.isEnabled).disposed(by: disposeBag)

        let pwdVaild = pwdTf.rx.text.orEmpty.map { (text) in
            return text.count > self.passwordMinCount
        }
        pwdVaild.bind(to: pwdLabel.rx.isHidden).disposed(by: disposeBag)

        Observable.combineLatest(usernameVaild, pwdVaild) { $0 && $1}
            .bind(to: loginBtn.rx.isEnabled)
            .disposed(by: disposeBag)

        loginBtn.rx.tap.subscribe(onNext: { () in
            print("点击一下")
        }).disposed(by: disposeBag)
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        person.name = person.name + "23456"
    }

    func setupKVO(){
        self.person.addObserver(self, forKeyPath: "name", options: .new, context: nil)
    }

    func setupButton() {


        self.btn.rx.tap
            .subscribe(onNext: { () in

            }).disposed(by: self.disposeBag)

        self.btn.rx.controlEvent(.touchUpInside)

    }

    func setupTextField() {

        self.tf.rx.text.orEmpty
            .subscribe(onNext: { (text) in
                print(text)
            }).disposed(by: self.disposeBag)


        self.tf.rx.text
            .bind(to: self.btn.rx.title())
            .disposed(by: self.disposeBag)

    }

    func setupScrollView() {
        scrollView.rx.contentOffset
            .subscribe(onNext: { [weak self](content) in

                self?.scrollView.backgroundColor = UIColor.init(red: content.y/255*0.6, green: content.y/255*0.6, blue: content.y/255*0.6, alpha: 1.0)

            })
        .disposed(by: self.disposeBag)

    }

    func setupGestureRecongizer() {
        let tap = UITapGestureRecognizer()
        self.label.addGestureRecognizer(tap)



    }

    func setupNotification() {
        NotificationCenter.default.rx.notification(Notification.Name.UIKeyboardWillShow)
            .subscribe(onNext: { (noti) in
                print(noti)
            }).disposed(by: self.disposeBag)
    }

    func setupTimer() {
        timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        timer.subscribe(onNext: { (num) in
            print(num)
        }).disposed(by: self.disposeBag)
    }


    func setupNetwork() {
        let url = URL(string: "https://")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in

        }.resume()


        URLSession.shared.rx.response(request: URLRequest.init(url: url!))
            .subscribe(onNext: { (res, data) in

            }).disposed(by: self.disposeBag)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print(change)
    }

    deinit {
        self.removeObserver(self.person, forKeyPath: "name")
    }

}

