//
//  RNMaskedEditText.swift
//  AwesomeProject
//
//  Created by Yadhukrishnan Ekambaran on 2021-01-27.
//
import UIKit

class RNMaskedEditText: MDCTextField, UITextFieldDelegate {
  
    var controller : MDCTextInputControllerFilled?
  
       override init(frame: CGRect) {
         super.init(frame: frame)
        setDefaultConfig()
       }
       
       required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
        setDefaultConfig()
       }

      @objc var pattern : String = "" {
         didSet {
          setPatternConfig()
         }
       }
       
       @objc var hint : String = "" {
           didSet {
             setHintConfig()
           }
         }
         
       
       @objc var digits : String = "" {
           didSet {
             setDigitConfig()
           }
         }
         
       
       @objc var error : String = "" {
           didSet {
            setErrorConfig()
           }
       }
       
      @objc var textValue : String = "" {
        didSet {
          setTextValueConfig()
        }
      }
      
      @objc var hiddenChar : String = "" {
        didSet {
          setHiddenCharConfig()
        }
      }
     
     @objc var onTextChanged: RCTBubblingEventBlock?
     @objc var onFocusChange: RCTBubblingEventBlock?
     @objc var onLimitReached: RCTBubblingEventBlock?
     
     func setDefaultConfig() {
        self.delegate = self
        controller = MDCTextInputControllerFilled(textInput: self);
     }
  
      func setPatternConfig() {
        formatter()
      }
  
    func setHintConfig() {
      guard let controller = controller else {
        return
      }
      
      controller.placeholderText = hint
    }
    
    func setDigitConfig() {
      if (digits.containsAlphs()) {
        self.keyboardType = .default
      } else {
        self.keyboardType = .numberPad
      }
    }
  
    func setErrorConfig() {
      guard let controller = controller else {
        return
      }
      
      if (error.count > 0) {
        controller.setErrorText(error, errorAccessibilityValue: .some(error))
      } else {
        controller.setErrorText(nil, errorAccessibilityValue: nil)
      }
      
    }
  
  func setTextValueConfig() {
    if (textValue.count > 0) {
      self.text = textValue
      formatter()
    }
  }
  
  func setHiddenCharConfig() {
    print("-- INSIDE  HIDDEN CONFIG -- \(hiddenChar)")
    if (hiddenChar.count > 0) {
      self.isEnabled = false
    }
  }

}

extension RNMaskedEditText {
  
  func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
    guard let onFocusChange = self.onFocusChange else { return }
       
    let params: [String : Any] = ["text": textField.text!, "focus": false]
    onFocusChange(params)
  }
  
  func textFieldDidChangeSelection(_ textField: UITextField) {
    formatter()
  }
  
  func formatter() {
    var text = self.text!
    text = text.stripped
  
    if (text.count == 0) {
        return;
    }
    
    var formattedText = ""
    let letters = [Character](text)
    let patternLetters = [Character](pattern)
    var patternPosition = 0
    for letter in letters {
      if (pattern.count > 0) {
        if (letter.isValidChar() || hiddenChar.count > 0) {
              var patternChar = patternLetters[patternPosition]
              patternPosition = patternPosition + 1
              while (patternChar != "#") {
                  formattedText += String(patternChar)
                  patternChar = patternLetters[patternPosition]
                  patternPosition = patternPosition + 1
              }
          
          formattedText += String(letter.uppercased())
          print("--- formattedText --- \(formattedText)")
        }
      } else {
        formattedText += String(letter.uppercased())
      }
    }
    
    self.delegate = nil
    self.text = formattedText
    self.delegate = self
  
    guard let onTextChanged = self.onTextChanged else { return }
    let params: [String : Any] = ["text": formattedText]
    onTextChanged(params)
    
    if (formattedText.count == pattern.count) {
      guard let onLimitReached = self.onLimitReached else { return }
      
      let params: [String : Any] = ["text": formattedText]
      onLimitReached(params)
    }
  }
  
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      let text = textField.text!
      print("--- shouldChangeCharactersIn --- \(text)")
      if (pattern.count == 0) {
        return true;
      }
    
      if (string.count == 0) {
          return true
      }
      
      if (text.count >= pattern.count) {
          return false
      }
      
      return true;
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.endEditing(true)
    return false
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
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890*")
        return self.filter {okayChars.contains($0) }
    }
  
    func containsAlphs() -> Bool {
      let letters = NSCharacterSet.letters

      let range = self.rangeOfCharacter(from: letters)

      if range != nil {
        return true
      }
      else {
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
