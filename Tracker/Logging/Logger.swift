//
//  Logger.swift
//  Tracker
//
//  Created by Александр Торопов on 29.12.2024.
//

import Foundation

enum Logger {
    private enum LogLevel {
        case debug
        case error
        
        fileprivate var prefix: String {
            switch self {
            case .debug:
                return "DEBUG"
            case .error:
                return "ERROR"
            }
        }
    }
    
    private struct Context {
        let file: String
        let function: String
        let line: Int
        
        var description: String {
            return "file: \((file as NSString).lastPathComponent), function: \(function), line: \(line)"
        }
    }
    
    private static func handleLog(level: LogLevel, message: String, context: Context? = nil) {
        var log = "\(level.prefix): \(message)"
        if let description = context?.description {
            log += " (\(description))"
        }
        
        #if DEBUG
        print(log)
        #endif
    }
    
    static func debug(
        _ message: String,
        shouldLogContext: Bool = false,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let context = shouldLogContext ? Context(file: file, function: function, line: line): nil
        handleLog(level: .debug, message: message, context: context)
    }
    
    static func error(
        _ message: String,
        shouldLogContext: Bool = true,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let context = shouldLogContext ? Context(file: file, function: function, line: line): nil
        handleLog(level: .error, message: message, context: context)
    }
}
