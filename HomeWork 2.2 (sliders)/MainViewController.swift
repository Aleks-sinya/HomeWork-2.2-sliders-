//
//  MainViewController.swift
//  HomeWork 2.2 (sliders)
//
//  Created by Алексей Синяговский on 18.03.2022.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func setBackgroundColor(for color: UIColor)
}

class MainViewController: UIViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingsVC = segue.destination as? SettingsViewController else { return }
        settingsVC.delegate = self
        settingsVC.viewColor = view.backgroundColor
    }
}
// MARK: - SettingsViewControllerDelegate
extension MainViewController: SettingsViewControllerDelegate {
    func setBackgroundColor(for color: UIColor) {
        view.backgroundColor = color
    }
    
}
