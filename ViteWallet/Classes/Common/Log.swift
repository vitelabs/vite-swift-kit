//
//  Log.swift
//  Pods
//
//  Created by Stone on 2018/12/11.
//

import Foundation

public func printLog<T>(_ message: T,
                 file: String = #file,
                 method: String = #function,
                 line: Int = #line)
{
    #if DEBUG
    guard LogConfig.instance.isEnable else { return }
    let fileName = (file as NSString).lastPathComponent

    if !LogConfig.instance.whiteList.isEmpty && !LogConfig.instance.whiteList.contains(fileName) {
        return
    }

    if !LogConfig.instance.blackList.isEmpty && LogConfig.instance.blackList.contains(fileName) {
        return
    }

    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.current
    dateFormatter.dateFormat = "HH:mm:ss.SSS"
    let time = dateFormatter.string(from: Date())
    print("📣 \(time) \((fileName as NSString).deletingPathExtension)[\(line)], \(method): \(message)")
    #endif
}

public class LogConfig {

    public static let instance = LogConfig()
    private init() {}

    public var whiteList: [String] = []
    public var blackList: [String] = []
    public var isEnable = false
}
