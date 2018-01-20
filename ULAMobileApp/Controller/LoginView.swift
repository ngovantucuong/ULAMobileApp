//
//  ViewController.swift
//  ULAMobileApp
//
//  Created by ngovantucuong on 1/16/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import Firebase

class LoginView: UIViewController, UITextFieldDelegate, GIDSignInUIDelegate {

    @IBOutlet weak var inputNumberPhoneTextField: UITextField!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var gmailButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputNumberPhoneTextField.delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        facebookButton.addTarget(self, action: #selector(handleSignInFacebook), for: .touchUpInside)
        gmailButton.addTarget(self, action: #selector(handleSignInGmail), for: .touchUpInside)
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        performSegue(withIdentifier: "showInputNumberPhoneView", sender: self)
        
        return false
    }
    
    @objc func handleSignInFacebook() {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if error != nil {
                print("Failed to login:  \(error!.localizedDescription)")
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    let alertController = UIAlertController(title: "Login error", message: error.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                
                let databaseRef = Database.database().reference()
                guard let uid = user?.uid else {  return }
                databaseRef.child("user-profiles").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    let snapshot = snapshot.value as? NSDictionary
                    if snapshot == nil {
                        databaseRef.child("user-profiles").child(uid).child("name").setValue(user?.displayName)
                        if user?.email == nil {
                            let email = "\(user!.displayName ?? "keylia")@gmail.com"
                            databaseRef.child("user-profiles").child(uid).child("email").setValue(email)
                        }
                        
                        databaseRef.child("user-profiles").child(uid).child("email").setValue(user?.email)
                    }
                    
                    if let inputNumberPhoneView = self.storyboard?.instantiateViewController(withIdentifier: "InputNumberPhoneView") {
                        self.present(inputNumberPhoneView, animated: true, completion: nil)
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            })
        }
    }
    
    @objc func handleSignInGmail() {
        GIDSignIn.sharedInstance().signIn()
    }
}

