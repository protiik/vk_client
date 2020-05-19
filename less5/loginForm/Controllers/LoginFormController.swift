//
//  LoginFormController.swift
//  loginForm
//
//  Created by prot on 10/02/2020.
//  Copyright © 2020 prot. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginFormController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textFieldLogin: UITextField!
    @IBOutlet weak var textFieldPass: UITextField!
    @IBOutlet weak var labelLogin: UILabel!
    @IBOutlet weak var buttonIn : UIButton!
    var requestHandler: UInt = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)) //переменная для закрытия клавитуры при тапе
        scrollView.addGestureRecognizer(tapGesture) // закрытие клавитуры
        
        buttonIn.layer.cornerRadius = 20
    }
    //vot@mail.ru / 123456
    @IBAction func goNext(_ sender: Any) {
        var id:String?
        guard let email = textFieldLogin.text, let pass = textFieldPass.text else {return}
        let db = Database.database().reference()
        Auth.auth().signIn(withEmail: email, password: pass) {(result, error) in
            id = result?.user.uid ?? ""
            print(id ?? "")
            db.child("id").updateChildValues(["1": id ?? ""])
            if result?.user != nil {
                self.performSegue(withIdentifier: "next", sender: self)
            }
            
        }
    }
    // Ошибка авторизации
//    func showInError() {
//
//        let alertVC = UIAlertController(title: "Ошибка", message: "Неверный логин или пароль", preferredStyle: .alert)
//        let action = UIAlertAction(title: "Ok", style: .default) { _ in
//            print("Ок clicked")
//        }
//        alertVC.addAction(action)
//
//        present(alertVC, animated: true, completion: nil)
//    }
    
    
//    func checkLogin() -> Bool {
//        if let login = textFieldLogin.text,
//            let pass = textFieldPass.text {
//
//            if login == "admin", pass == "admin" {
//                print("Успешная авторизация")
//                return true
//            }else {
//                print("Не успешная авторизация")
//                return false
//            }
//        };return false
//    }
//
//
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        if checkLogin(){
//            return true
//        }else{
//            showInError()
//            return false
//        }
//
//    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //скрыть navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
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
    
    //выход на начальный контроллер
    @IBAction func exit(unwindSegue: UIStoryboardSegue) {
        print("Welocme back")
    }
    
}
