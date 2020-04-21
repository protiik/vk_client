//
//  ViewController.swift
//  loginForm
//
//  Created by prot on 30/01/2020.
//  Copyright © 2020 prot. All rights reserved.
//

import UIKit

class LoginFormController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textFieldLogin: UITextField!
    @IBOutlet weak var textFieldPass: UITextField!
    @IBOutlet weak var labelLogin: UILabel!
    
    
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)) //переменная для закрытия клавитуры при тапе
            scrollView.addGestureRecognizer(tapGesture) // закрытие клавитуры
        }
        
    
    func showInError() {
        
        let alertVC = UIAlertController(title: "Ошибка", message: "Неверный логин или пароль", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            print("Ок clicked")
        }
        alertVC.addAction(action)
        
        present(alertVC, animated: true, completion: nil)
        }
    
    func checkLogin() -> Bool {
        if let login = textFieldLogin.text,
            let pass = textFieldPass.text {
                      
            if login == "admin", pass == "admin" {
                print("Успешная авторизация")
                return true
            }else {
                print("Не успешная авторизация")
                return false
            }
               };return false
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if checkLogin(){
            return true
        }else{
            showInError()
            return false
        }
        
    }
    
    
        
        
        override func viewWillAppear(_ animated: Bool) {
               super.viewWillAppear(animated)
               
            // Подписываемся на два уведомления: одно приходит при появлении клавиатуры

               NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            // Второе — когда она пропадает
               NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        // Когда клавиатура появляется
        @objc func keyboardWillShown ( notification : Notification) {
            // Получаем размер клавиатуры
               let info = notification.userInfo! as NSDictionary
               let size = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
               let contentInsents = UIEdgeInsets(top: 0, left: 0, bottom: size.height, right: 0)
            // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
               self.scrollView?.contentInset = contentInsents
               self.scrollView.scrollIndicatorInsets = contentInsents
               
        }
           //Когда клавиатура исчезает
        @objc func keyboardWillHide ( notification : Notification) {
            // Устанавливаем отступ внизу UIScrollView, равный 0
               scrollView.contentInset = .zero
               
        }
        //клик по пустому месту на экране сворачивает клаву
        @objc func hideKeyboard() {
            self.scrollView.endEditing(true)
        }
    
        @IBAction func exit( unwindSegue: UIStoryboardSegue) {
        print("Welocme back")
        }   

    }


