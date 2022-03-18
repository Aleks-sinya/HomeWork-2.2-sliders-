//
//  SettingsViewController.swift
//  HomeWork 2.2 (sliders)
//
//  Created by Алексей Синяговский on 04.03.2022.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func setBackgroundColor(for color: UIColor)
}

class SettingsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var redValueLabel: UILabel!
    @IBOutlet weak var greenValueLabel: UILabel!
    @IBOutlet weak var blueValueLabel: UILabel!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var redTextField: UITextField!
    @IBOutlet weak var greenTextField: UITextField!
    @IBOutlet weak var blueTextField: UITextField!
    
    // MARK: - Properties
    var delegate: SettingsViewControllerDelegate!
    var mainVCBackgroundColor: UIColor!
    var setValueTF: SetValueTF!
    
    // MARK: - OverrideMethods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorView.layer.cornerRadius = 15
        
        redSlider.minimumTrackTintColor = .red
        greenSlider.minimumTrackTintColor = .green
        
        setColor()
        setValue()
        defaultSettings()
        
        redTextField.delegate = self
        greenTextField.delegate = self
        blueTextField.delegate = self
        
        createToolbar(textField: redTextField)
        createToolbar(textField: greenTextField)
        createToolbar(textField: blueTextField)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    // MARK: - KeyboardNotification
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
            as? NSValue)?.cgRectValue
        {
            
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - IBActions
    @IBAction func rgbSlider(_ sender: UISlider) {
        setColor()
        switch sender {
        case redSlider:
            redValueLabel.text = string(from: redSlider)
            redTextField.text = string(from: redSlider)
        case greenSlider:
            greenValueLabel.text = string(from: greenSlider)
            greenTextField.text = string(from: greenSlider)
        default:
            blueValueLabel.text = string(from: blueSlider)
            blueTextField.text = string(from: blueSlider)
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        view.endEditing(true)
        delegate.setBackgroundColor(for: colorView.backgroundColor ?? .gray)
        dismiss(animated: true)
    }
    
    
    // MARK: - PrivateMethods
    private func setColor() {
        colorView.backgroundColor = UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1
        )
    }
    
    private func setValue() {
        let sliderValue = CIColor(color: mainVCBackgroundColor)
        
        redSlider.value = Float(sliderValue.red)
        greenSlider.value = Float(sliderValue.green)
        blueSlider.value = Float(sliderValue.blue)
        
        colorView.backgroundColor = mainVCBackgroundColor
    }
    
    private func defaultSettings() {
        redValueLabel.text = string(from: redSlider)
        redTextField.text = string(from: redSlider)
        
        greenValueLabel.text = string(from: greenSlider)
        greenTextField.text = string(from: greenSlider)
        
        blueValueLabel.text = string(from: blueSlider)
        blueTextField.text = string(from: blueSlider)
        
        setColor()
    }
    
    private func string(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
}

// MARK: - UITextFieldDelegate
extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let newValue = textField.text else { return }
        guard let numberValue = Float(newValue) else { return }
        guard textField.text?.isEmpty == false else {return }
        
        if numberValue != Float(numberValue) {
            showAlert(title: "Wrong format", message: "Please insert correct values")
        }
        
        if numberValue < 0 && numberValue > 1 {
            showAlert(title: "Wrong format", message: "Please insert correct values")
        }
        
        if textField == redTextField {
            setValueTF?.redValueTF = numberValue
        } else if
            textField == greenTextField {
            setValueTF?.greenValueTF = numberValue
        } else if
            textField == blueTextField {
            setValueTF?.blueValueTF = numberValue
        }
    }
    // MARK: - ToolBar
    func createToolbar(textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(dismissKeyboard)
        )
        let cancelButton = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(dismissKeyboard)
        )
        let spaceButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        toolBar.tintColor = .blue
        toolBar.barTintColor = .white
        
        textField.inputAccessoryView = toolBar
        textField.delegate = self
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: AlertController
extension SettingsViewController {
    private func showAlert(
        title: String,
        message: String,
        textField: UITextField? = nil
    )
    {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            textField?.text = ""
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
