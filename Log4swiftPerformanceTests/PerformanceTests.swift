//
//  PerformanceTests.swift
//  Log4swift
//
//  Created by Jérôme Duquennoy on 15/07/2015.
//  Copyright © 2015 Jérôme Duquennoy. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import XCTest
import Log4swift

class PerformanceTests: XCTestCase {

  func testNSLogPerformanceTest() {
    // This is an example of a performance test case.
    self.measureBlock() {
      for _ in 0...5000 {
        NSLog("This is a simple log");
      }
    }
  }
  
  func testConsoleLoggerWithFormatterPerformanceTest() {
    let formatter = try! PatternFormatter(identifier: "formatter", pattern: "%d{%D %R} %m");
    let stdOutAppender = StdOutAppender("appender");
    stdOutAppender.errorThresholdLevel = .Debug;
    stdOutAppender.formatter = formatter;
    let logger = Logger(identifier: "");
    logger.appenders = [stdOutAppender];
    
    // This is an example of a performance test case.
    self.measureBlock() {
      for _ in 0...5000 {
        logger.error("This is a simple log");
      }
    }
  }
  
  func testFileLoggerWithFormatterPerformanceTest() {
    let formatter = try! PatternFormatter(identifier: "formatter", pattern: "%d %m");
    let tempFilePath = try! self.createTemporaryFileUrl();
    let fileAppender = FileAppender(identifier: "test.appender", filePath: tempFilePath);
    fileAppender.formatter = formatter;
    let logger = Logger(identifier: "");
    logger.appenders = [fileAppender];
    
    // This is an example of a performance test case.
    self.measureBlock() {
      for _ in 0...5000 {
        logger.error("This is a simple log");
      }
    }

    unlink((tempFilePath as NSString).fileSystemRepresentation);
  }
  
  func testASLLoggerWithFormatterPerformanceTest() {
    let aslAppender = ASLAppender("appender");
    let logger = Logger(identifier: "");
    logger.appenders = [aslAppender];
    
    // This is an example of a performance test case.
    self.measureBlock() {
      for _ in 0...5000 {
        logger.error("This is a perf test log");
      }
    }
  }

  private func createTemporaryFileUrl() throws -> String {
    let temporaryDirectoryUrl = NSURL(fileURLWithPath:NSTemporaryDirectory());
    let temporaryFileUrl = temporaryDirectoryUrl.URLByAppendingPathComponent(NSUUID().UUIDString + ".log");
    return temporaryFileUrl.path!
  }

}
