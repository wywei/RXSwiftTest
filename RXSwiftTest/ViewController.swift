//
//  ViewController.swift
//  RXSwiftTest
//
//  Created by Andy on 2018/1/23.
//  Copyright © 2018年 wangyawei. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  把一系列数转化为事件序列
//        let _ = Observable.of(1,2,3,4).subscribe{
//            event in
//            print(event)
//        }
        
        
       
//        let generated = Observable.generate(
//            initialState: 0, condition: {$0<20}, iterate: {$0+4}
//        )
//
//        _ = generated.subscribe{
//            print($0)
//        }
        
        let error = NSError(domain:"Test",code:-1,userInfo:nil)
        
        let erroredSequence = Observable<Any>.error(error)
        
        _ = erroredSequence.subscribe{
            print($0)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

