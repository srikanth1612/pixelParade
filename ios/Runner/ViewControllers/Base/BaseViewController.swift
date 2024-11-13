//
//  BaseViewController.swift
//  TemplateProject
//
//  Created by Pavel Pronin on 13/07/2017.
//  Copyright © 2017 Live Typing. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, KeyboardStateDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        registerForKeyboardNotifications(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unregisterFromKeyboardNotifications()
    }
    
    func keyboardWillTransition(_ state: KeyboardState) {
        // keyboard will show or hide
    }
    
    func keyboardTransitionAnimation(_ state: KeyboardState) {
        // keyboard animation
    }
    
    func keyboardDidTransition(_ state: KeyboardState) {
        // keyboard animation finished
    }

    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
    }

}

extension BaseViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let isButtonTouched = touch.view?.isKind(of: UIButton.self) else { return true }
        return !isButtonTouched
    }
    
}
