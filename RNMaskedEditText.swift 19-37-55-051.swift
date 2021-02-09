//
//  RNMaskedEditText.swift
//  TiffinFinds
//
//  Created by Yadhukrishnan Ekambaran on 2021-01-27.
//
import UIKit

class RNMaskedEditText: UITextField, UITextFieldDelegate {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }

  @objc var pattern = "" {
    didSet {
      setupView()
    }
  }
  
  @objc var hint = "" {
    didSet {
      setupView()
    }
  }
  
  @objc var digits = "" {
    didSet {
      setupView()
    }
  }
  
  @objc var error = "" {
    didSet {
      setupView()
    }
  }
  
  @objc var afterTextChanged: RCTBubblingEventBlock?
  @objc var onFocusChange: RCTBubblingEventBlock?
  @objc var onLimitReached: RCTBubblingEventBlock?
  
  func setupView() {
    self.delegate = self
    self.placeholder = hint
    if (digits.containsAlphs()) {
      self.keyboardType = .default
    } else {
      self.keyboardType = .numberPad
    }
  }
}

extension RNMaskedEditText {
  
  func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
    guard let onFocusChange = self.onFocusChange else { return }
       
    let param: [String : Any] = ["text": textField.text!]
       onFocusChange(param)
  }
  
  func textFieldDidChangeSelection(_ textField: UITextField) {
      var text = textField.text!
      
      text = text.stripped
  
      if (text.count == 0) {
          return;
      }
      
      var formattedText = ""
      let letters = [Character](text)
      let patternLetters = [Character](pattern)
      var patternPosition = 0
      for letter in letters {
          if (letter.isValidChar()) {
              var patternChar = patternLetters[patternPosition]
              patternPosition = patternPosition + 1
              while (patternChar != "#") {
                  formattedText += String(patternChar)
                  patternChar = patternLetters[patternPosition]
                  patternPosition = patternPosition + 1
              }
              
              formattedText += String(letter)
          }
      }
      
      textField.delegate = nil
      textField.text = formattedText
      textField.delegate = self
    
    guard let afterTextChanged = self.afterTextChanged else { return }
    
    let afterParam: [String : Any] = ["text": formattedText]
    afterTextChanged(afterParam)
    
    if (formattedText.count == pattern.count) {
      guard let onLimitReached = self.onLimitReached else { return }
      
      let params: [String : Any] = ["text": formattedText]
      onLimitReached(params)
    }
  }
  
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      let text = textField.text!
      if (string.count == 0) {
          return true
      }
      if (text.count >= pattern.count) {
          return false
      }
      
      return true;
  }
  
}

extension String {
    func replace(_ with: String, at index: Int) -> String {
        var modifiedString = String()
        for (i, char) in self.enumerated() {
            modifiedString += String((i == index) ? with : String(char))
        }
        return modifiedString
    }
    
    var stripped: String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
        return self.filter {okayChars.contains($0) }
    }
  
    func containsAlphs() -> Bool {
      let letters = NSCharacterSet.letters

      let range = self.rangeOfCharacter(from: letters)

      if range != nil {
        print("--- contains letter ---")
        return true
      }
      else {
        print("--- not contains letter ---")
        return false
      }
    }
}

extension Character {
    
    func isValidChar() -> Bool {
        if (self.isLetter) {
            return true
        } else if (self.isNumber) {
            return true
        }
        
        return false
    }

}


@objc (RNMaskedEditTextManager)
class RNMaskedEditTextManager: RCTViewManager {
 
  override static func requiresMainQueueSetup() -> Bool {
    return true
  }
 
  override func view() -> UIView! {
    return RNMaskedEditText()
  }
 
}
