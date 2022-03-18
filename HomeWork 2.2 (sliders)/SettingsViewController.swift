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
    
    // MARK: - OverrideMethods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorView.layer.cornerRadius = 15
        
        redSlider.minimumTrackTintColor = .red
        greenSlider.minimumTrackTintColor = .green
        
        setColor()
        setValue()
        defaultSettings()
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

