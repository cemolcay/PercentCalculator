//
//  ViewController.swift
//  PercentCalc
//
//  Created by Cem Olcay on 16/09/2017.
//  Copyright © 2017 cemolcay. All rights reserved.
//

import Cocoa

enum PercentCalculator {
  case whatIsXpercentOfY
  case xIsYpercentOf
  case xIsWhatPercentOfY
  case percentless

  func calculate(x: Double, y: Double) -> Double {
    switch self {
    case .whatIsXpercentOfY:
      return x / 100.0 * y
    case .xIsWhatPercentOfY:
      return x * 100.0 / y
    case .xIsYpercentOf:
      return 100.0 / y * x
    case .percentless:
      return (x - y) / 100.0
    }
  }
}

class PercentCalculatorViewModel: NSObject, NSTextFieldDelegate {
  var type: PercentCalculator
  var xTextField: NSTextField
  var yTextField: NSTextField
  var resultLabel: NSTextField

  init(type: PercentCalculator, x: NSTextField, y: NSTextField, result: NSTextField) {
    self.type = type
    xTextField = x
    yTextField = y
    resultLabel = result
    super.init()
    xTextField.delegate = self
    yTextField.delegate = self
  }

  override func controlTextDidChange(_ obj: Notification) {
    guard let x = Double(xTextField.stringValue),
      let y = Double(yTextField.stringValue)
      else { resultLabel.stringValue = ""; return }

    resultLabel.stringValue = String(format: "%.2f%@", type.calculate(x: x, y: y), type == .xIsWhatPercentOfY ? "%" : "")
  }
}

class ViewController: NSViewController {
  @IBOutlet weak var xTextField1: NSTextField!
  @IBOutlet weak var xTextField2: NSTextField!
  @IBOutlet weak var xTextField3: NSTextField!
  @IBOutlet weak var yTextField1: NSTextField!
  @IBOutlet weak var yTextField2: NSTextField!
  @IBOutlet weak var yTextField3: NSTextField!
  @IBOutlet weak var resultTextField1: NSTextField!
  @IBOutlet weak var resultTextField2: NSTextField!
  @IBOutlet weak var resultTextField3: NSTextField!
  var viewModel1: PercentCalculatorViewModel!
  var viewModel2: PercentCalculatorViewModel!
  var viewModel3: PercentCalculatorViewModel!
  var viewModel4: PercentCalculatorViewModel!

  @IBAction func quitButtonPressed(sender: NSButton) {
    NSApplication.shared().terminate(sender)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    viewModel1 = PercentCalculatorViewModel(
      type: .whatIsXpercentOfY,
      x: xTextField1,
      y: yTextField1,
      result: resultTextField1)

    viewModel2 = PercentCalculatorViewModel(
      type: .xIsWhatPercentOfY,
      x: xTextField2,
      y: yTextField2,
      result: resultTextField2)
    
    viewModel3 = PercentCalculatorViewModel(
      type: .xIsYpercentOf,
      x: xTextField3,
      y: yTextField3,
      result: resultTextField3)
    
    viewModel4 = PercentCalculatorViewModel(
      type: .percentless,
      x: xTextField4,
      y: yTextField4,
      result: resultTextField4)
  }
}

