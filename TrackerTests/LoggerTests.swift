//
//  LoggerTests.swift
//  TrackerTests
//
//  Created by Александр Торопов on 12.01.2025.
//

import XCTest
@testable import Tracker

final class LoggerTests: XCTestCase {
    func testDebugLogWithoutContext() {
        let output = captureOutput {
            Logger.debug("Test debug message", shouldLogContext: false)
        }
        XCTAssertTrue(output.contains("DEBUG: Test debug message"))
    }
    
    func testDebugLogWithContext() {
        let output = captureOutput {
            Logger.debug("Test debug message", shouldLogContext: true, file: "TestFile.swift", function: "testFunction()", line: 42)
        }
        XCTAssertTrue(output.contains("DEBUG: Test debug message"))
        XCTAssertTrue(output.contains("file: TestFile.swift, function: testFunction(), line: 42"))
    }
    
    func testErrorLogWithContext() {
        let output = captureOutput {
            Logger.error("Test error message", shouldLogContext: true, file: "ErrorFile.swift", function: "errorFunction()", line: 99)
        }
        XCTAssertTrue(output.contains("ERROR: Test error message"))
        XCTAssertTrue(output.contains("file: ErrorFile.swift, function: errorFunction(), line: 99"))
    }
    
    func testErrorLogWithoutContext() {
        let output = captureOutput {
            Logger.error("Test error message", shouldLogContext: false)
        }
        XCTAssertTrue(output.contains("ERROR: Test error message"))
        XCTAssertFalse(output.contains("file:"))
    }
    
    private func captureOutput(_ block: () -> Void) -> String {
        let originalOutput = dup(fileno(stdout))
        let pipe = Pipe()
        dup2(pipe.fileHandleForWriting.fileDescriptor, fileno(stdout))
        
        block()
        
        fflush(stdout)
        dup2(originalOutput, fileno(stdout))
        
        pipe.fileHandleForWriting.closeFile()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8) ?? ""
    }
}

