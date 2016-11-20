//
//  Module1.swift
//  PageControllerDemo
//
//  Created by wangfei on 2016/11/20.
//  Copyright © 2016年 fei.wang. All rights reserved.
//

import Foundation


class SubClass1: NonSubclassableParentClass {
    override func foo() {
        print(#function)
    }
    
    override func bar() {
        print(#function)
    }
    
//    override func baz() {
//        print(#function)
//    }
    
}
