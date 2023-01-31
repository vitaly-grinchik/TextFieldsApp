//
//  MainViewController.swift
//  TextFieldsApp
//
//  Created by Виталий Гринчик on 20.01.23.
//

import UIKit

final class MainViewController: UIViewController {

    private let userTextField = UITextField()
    private let passwordTextField = UITextField()
    private let bottomConstraint: CGFloat = 60
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerNotifications()
    }

    deinit {
        cancelNotifications()
    }

    
    private func setupUI() {
        addViews()
        setupViews()
        layout()
    }
    
    private func setupViews() {
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        setupTextFields()
    }
    
    private func setupTextFields() {
        userTextField.delegate = self
        passwordTextField.delegate = self
        
        userTextField.placeholder = "User"
        userTextField.backgroundColor = .white
        passwordTextField.placeholder = "Password"
        passwordTextField.backgroundColor = .white
        passwordTextField.isSecureTextEntry = true
    }
    
    private func layout() {
        userTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userTextField.widthAnchor.constraint(equalToConstant: 200),
            userTextField.heightAnchor.constraint(equalToConstant: 25),
            userTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            passwordTextField.widthAnchor.constraint(equalTo: userTextField.widthAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: userTextField.heightAnchor),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: userTextField.bottomAnchor, constant: 20),
            
            passwordTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomConstraint)
        ])
    }
    
    private func addViews() {
        view.addSubview(userTextField)
        view.addSubview(passwordTextField)
    }
    
    // Регистрируем нотификаторы для клавиатуры
    private func registerNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardOn),
            name: UIWindow.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardOff),
            name: UIWindow.keyboardWillHideNotification,
            object: nil
        )
    }

    private func cancelNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
    }

    private func getKeybordHightFor(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        if let keyboardFrame = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            return keyboardFrame.height
        } else {
            return 0
        }
    }
    
    
    @objc private func keyboardOn() {
        let safeAreaExists = view.safeAreaInsets.bottom != 0
        passwordTextField.bottomAnchor.constraint(
            equalTo: view.bottomAnchor,
            constant: bottomConstraint
        ).isActive = true
    }

    @objc private func keyboardOff() {
        
    }
}

// MARK: - UITextFieldDelegate
extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // clear newly appeared field
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = nil
        return true
    }
}
