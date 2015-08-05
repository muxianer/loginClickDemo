//
//  ViewController.swift
//  loginClickDemo
//
//  Created by Arivn Ren on 15/8/6.
//  Copyright (c) 2015年 Arivn Ren. All rights reserved.
//



import UIKit

extension UIButton {
    func disable() {
        self.enabled = false
        self.alpha = 0.5
    }
    func enable() {
        self.enabled = true
        self.alpha = 1
    }
}

extension UITextField {
    var notEmpty: Bool{
        get {
            return self.text != ""
        }
    }
    func validate(RegEx: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", RegEx)
        return predicate.evaluateWithObject(self.text)
    }
//    func validateEmail() -> Bool {
//        return self.validate("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}")
//    }
    func validatePhoneNumber() -> Bool {
        return self.validate("^\\d{11}$")
    }
    func validatePassWord() -> Bool {
        return self.validate("^[A-Z0-9a-z]{6,18}")
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var phoneNumberTextField: ElasticTextField!
    @IBOutlet weak var passWordTextField: ElasticTextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func editingChanged(sender: AnyObject) {
        
        if self.phoneNumberTextField.notEmpty && self.passWordTextField.notEmpty {
            self.loginButton.enable()
        } else {
            self.loginButton.disable()
        }
        
    }
    @IBAction func loginButtonClick(sender: AnyObject) {
        
        if self.phoneNumberTextField.validatePhoneNumber() {
            if self.passWordTextField.validatePassWord() {
//                self.loginButton.enabled = true
//                self.alert("验证成功")
            } else {
                self.alert("密码不正确")
            }
        } else {
            self.alert("手机账号不正确")
        }
    }
    
    func alert(message: String) {
        let alc = UIAlertController(title: message, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        //        alc.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alc, animated: true, completion: nil)
    }
    
    
}


