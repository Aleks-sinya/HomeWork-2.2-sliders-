//
//  MainViewController.swift
//  HomeWork 2.2 (sliders)
//
//  Created by Алексей Синяговский on 18.03.2022.
//

import UIKit


class MainViewController: UIViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationVC = segue.destination as? UINavigationController else { return }
        guard let settingsVC = navigationVC.topViewController as? SettingsViewController else { return }
        settingsVC.mainVCBackgroundColor = view.backgroundColor
        settingsVC.delegate = self
    }
}
// MARK: - SettingsViewControllerDelegate
extension MainViewController: SettingsViewControllerDelegate {
    func setBackgroundColor(for color: UIColor) {
        view.backgroundColor = color
    }
    
}
