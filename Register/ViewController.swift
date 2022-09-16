//
//  ViewController.swift
//  Register
//
//  Created by Kavya on 16/09/22.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var txtDatePicker: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
    
    private func initialSetUp() {
        txtName.delegate = self
        txtCountry.delegate = self
        showDatePicker()
        //To Show keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)) , name: UIResponder.keyboardWillShowNotification, object: nil)
        //To hide keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    //Submit button validation
    @IBAction func btnSubmitAction(_ sender: Any) {
        if self.txtName.text!.count == 0 {
            self.txtName.placeholder = "Enter valid name"
            self.showToast(message: "Invalid Name", font: .systemFont(ofSize: 12.0))
        } else if self.txtCountry.text!.count == 0 {
            self.txtCountry.placeholder = "Enter country name"
            self.showToast(message: "Invalid country", font: .systemFont(ofSize: 12.0))
        } else if self.txtDatePicker.text!.count == 0 {
            self.txtDatePicker.placeholder = "Enter valid Date of Birth"
            self.showToast(message: "Invalid Date of Birth", font: .systemFont(ofSize: 12.0))
        } else if !self.isValidEmail(testStr: txtEmail.text!) || self.txtEmail.text!.count == 0 //Checking the email validatione
        {
            self.txtEmail.placeholder = "Enter valid Email"
            self.showToast(message: "InValid Email", font: .systemFont(ofSize: 12.0))
            return
        } else {
            
        }
    }
    
    //Textfield delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtName {
            let inverseSet = NSCharacterSet(charactersIn:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz. ").inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")
            if !(string == filtered) {
                self.showToast(message: "Invalid Name", font: .systemFont(ofSize: 12.0))
                return false
            }
        }
        if textField == txtCountry {
            let inverseSet = NSCharacterSet(charactersIn:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz. ").inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")
            if !(string == filtered) {
                self.showToast(message: "Invalid Country", font: .systemFont(ofSize: 12.0))
                return false
            }
        }
        return true
    }
    
    //Email validation checking
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    //MARK: - Date Picker
    func showDatePicker() {
        //Formate Date
        datePicker.datePickerMode = .date
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        txtDatePicker.inputAccessoryView = toolbar
        txtDatePicker.inputView = datePicker
    }
    
    @objc func donedatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        txtDatePicker.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }
}


extension UIViewController {
    
    func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.red.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
