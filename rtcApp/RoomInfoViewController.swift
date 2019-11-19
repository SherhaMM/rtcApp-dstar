//
//  ViewController.swift
//  rtcApp
//
//  Created by Makcim Mikhailov on 17.11.19.
//  Copyright © 2019 Makcim Mikhailov. All rights reserved.
//

import UIKit

class RoomInfoViewController: UIViewController {
   
    var roomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 1, alpha: 0.8)
     
        view.layer.cornerRadius = 15
        return view
    }()
    var label: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 22)
        lbl.text = "Enter Your Room ID"
        lbl.sizeToFit()
        return lbl
    }()
    var textField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Example: 12345"
        field.backgroundColor = UIColor(white: 1, alpha: 1)
        field.layer.cornerRadius = 5
        return field
    }()
    var button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Go", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor.lightGray
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 4
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGray
        configureConstraints()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resignTextFieldResponder(_:)))
        tapGesture.cancelsTouchesInView = true
        view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view, typically from a nib.
    }
   
    private func configureConstraints() {
        view.addSubview(roomView)
        NSLayoutConstraint.activate([
            roomView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            roomView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            roomView.heightAnchor.constraint(equalToConstant: 150),
            roomView.widthAnchor.constraint(equalToConstant: 250)
            ])
        
        roomView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: roomView.topAnchor,constant: 20),
            label.centerXAnchor.constraint(equalTo: roomView.centerXAnchor)
            ])
        
        roomView.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: roomView.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: roomView.centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: roomView.leadingAnchor,constant: 5),
            textField.trailingAnchor.constraint(equalTo: roomView.trailingAnchor,constant: -5)
            ])
        
        roomView.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: textField.bottomAnchor,constant: 20),
            button.centerXAnchor.constraint(equalTo: roomView.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant:50)
            ])
    }

    @objc   private func buttonPressed(_ sender: UIButton) {
        guard let textString = textField.text, !textString.isEmpty else {
            showAlert(with: "Enter valid room ID")
            return
        }
        guard textString.count > 5 else {
            showAlert(with: "Room ID must contain 6 symbols or more")
            return
        }
        performCustomSegue(with: textString)
    }
    
    @objc private func resignTextFieldResponder(_ sender: Any) {
    textField.resignFirstResponder()
    }

    private func performCustomSegue(with id: String) {
        let callView = CallViewController(nibName: nil, bundle: nil)
        callView.roomName = id
        navigationController?.pushViewController(callView, animated: true)
    }
}

extension RoomInfoViewController {
    func showAlert(with text: String) {
        let alertController = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController,animated: true,completion: nil)
    }
}
