//
//  DispatchExtensions.swift
//  GreatApp
//
//  Created by chinaxxren 2019/4/9.
//  Copyright © 2019 WaQu. All rights reserved.
//

import UIKit

struct Lock {
    static var recursive: UnsafeMutablePointer<pthread_mutex_t> {
        let lock = UnsafeMutablePointer<pthread_mutex_t>.allocate(capacity: MemoryLayout<pthread_mutex_t>.size)
        let attr = UnsafeMutablePointer<pthread_mutexattr_t>.allocate(capacity: MemoryLayout<pthread_mutexattr_t>.size)
        pthread_mutexattr_init(attr)
        pthread_mutexattr_settype(attr, PTHREAD_MUTEX_RECURSIVE)
        pthread_mutex_init(lock, attr)
        pthread_mutexattr_destroy(attr)
        return lock
    }
}

extension DispatchQueue {
    /// 主线程安全的异步派发
    /// https://github.com/onevcat/Kingfisher/blob/master/Sources/Utility/CallbackQueue.swift
    func mainAsync(_ block: @escaping () -> ()) {
        if self === DispatchQueue.main && Thread.isMainThread {
            block()
        } else {
            async {
                block()
            }
        }
    }
}
