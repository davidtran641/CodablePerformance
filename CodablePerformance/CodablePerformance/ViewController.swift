//
//  ViewController.swift
//  CodablePerformance
//
//  Created by Tran Duc on 10/17/19.
//  Copyright © 2019 David. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func startTestButtonPressed(_ sender: Any) {
    PerformanceTest().test()
  }
}

final class PerformanceTest {
  private var data: Data!

  func test() {
    data = createData(count: 10 * 1000)
    testAutoDecode()
    testManualDecode()
    testManualDecodeWithSafeCasting()
  }

  func testAutoDecode() {
    let parser = ItemParser()
    self.measure {
      let _ = try! parser.parse(from: data)
    }
  }

  func testManualDecode() {
    let parser = ItemParserManual()
    self.measure {
      let _ = try! parser.parse(from: data)
    }
  }

  func testManualDecodeWithSafeCasting() {
    let parser = ItemParserManualCast()
    self.measure {
      let _ = try! parser.parse(from: data)
    }
  }

  private func createData(count: Int) -> Data {
    let response = ItemResponse(result: (0..<count).map { Item(id: $0, itemTitle: "Title at \($0)") })
    let encoder = JSONEncoder()
    return try! encoder.encode(response)
  }

  private func measure(function: String = #function, _ block: () -> Void) {
    var runningTimes: [Double] = []
    for _ in 0..<10 {
      let time = CFAbsoluteTimeGetCurrent()
      block()
      let runTime = CFAbsoluteTimeGetCurrent() - time
      runningTimes.append(runTime)
    }

    let average = runningTimes.reduce(Double(0), +) / Double(runningTimes.count)
    let expression = NSExpression(forFunction: "stddev:", arguments: [NSExpression(forConstantValue: runningTimes)])
    let standardDeviation = expression.expressionValue(with: nil, context: nil) as! Double
    print("\(function):\n - average: \(average)\n - standard deviation: \(standardDeviation * 100) %\n -  values: \(runningTimes)\n")
  }

}

