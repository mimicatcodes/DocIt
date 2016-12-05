//
//  RegisterViewController.swift
//  emeraldHail
//
//  Created by Enrique Torrendell on 11/18/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class RegisterViewController: UIViewController {
    
    // MARK: Outlets

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var createAccount: UIButton!
    @IBOutlet weak var alreadyHaveAccount: UIButton!
    
    var googleSignInButton : UIButton!

    // MARK: Properties

    let store = DataStore.sharedInstance
    let family = FIRDatabase.database().reference().child("family")

    // MARK: Loads

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configureGoogleButton()
        hideKeyboardWhenTappedAround()
        GIDSignIn.sharedInstance().uiDelegate = self
        checkLogin()
    }

    override func viewWillAppear(_ animated: Bool) {
        setupViews()
        configureGoogleButton()
    }

    // MARK: Actions

    @IBAction func createAccountPressed(_ sender: Any) {
        register()
    }

    @IBAction func signInPressed(_ sender: Any) {
        // If on the create account screen, if they already have an account...take them to the sign in screen
        //        self.performSegue(withIdentifier: "showLogin", sender: nil)
        self.performSegue(withIdentifier: "showLogin", sender: nil)
    }

    // This function enables/disables the createAccount button when the fields are empty/not empty.
    @IBAction func textDidChange(_ sender: UITextField) {
        if !(emailField.text?.characters.isEmpty)! && !(passwordField.text?.characters.isEmpty)! {
            createAccount.isEnabled = true
            createAccount.backgroundColor = Constants.Colors.scooter
        } else {
            createAccount.isEnabled = false
            createAccount.backgroundColor = UIColor.lightGray
        }
    }
  

    // MARK: Functions

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboardView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    func dismissKeyboardView() {
        view.endEditing(true)
    }

    func setupViews() {
        // Make the email field become the first repsonder and show keyboard when this vc loads
        emailField.becomeFirstResponder()

        // Set error label to "" on viewDidLoad
        // Clear the text fields when logging out and returning to the createAccount screen
        errorLabel.text = nil
        emailField.text = nil
        passwordField.text = nil

        emailField.layer.cornerRadius = 2
        emailField.layer.borderColor = UIColor.lightGray.cgColor

        passwordField.layer.cornerRadius = 2
        passwordField.layer.borderColor = UIColor.lightGray.cgColor

        createAccount.isEnabled = false
        createAccount.backgroundColor = UIColor.lightGray
        createAccount.layer.cornerRadius = 2
    }

    func configureGoogleButton(){
        googleSignInButton = UIButton(type: .system)
        googleSignInButton.setBackgroundImage(#imageLiteral(resourceName: "googleImageButton"), for: .normal)
        googleSignInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        googleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(googleSignInButton)
        
        googleSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        googleSignInButton.bottomAnchor.constraint(equalTo: alreadyHaveAccount.topAnchor, constant: 10).isActive = true
        googleSignInButton.topAnchor.constraint(equalTo: createAccount.bottomAnchor, constant: 10).isActive = true
        googleSignInButton.heightAnchor.constraint(equalTo: alreadyHaveAccount.heightAnchor)
        googleSignInButton.widthAnchor.constraint(equalTo: alreadyHaveAccount.widthAnchor)
        view.layoutIfNeeded()
        
    }
    
    func checkLogin(){
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if user != nil {
                // User is signed in
            } else {
                self.register()
            }
        })
    }
    
    func register() {
        guard let email = emailField.text, let password = passwordField.text else { return }

        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                // TODO: Format the error.localizedDescription for natural language, ex. "Invalid email", "Password must be 6 characters or more", etc.
                // Set errorLabel to the error.localizedDescription
                self.errorLabel.text = error.localizedDescription
                print("===========================\(error.localizedDescription)")
                return
            }
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                }

                // Set the sharedInstance familyID to the current user.uid
                self.store.family.id = (user?.uid)!

                self.family.child((self.store.family.id)).child("email").setValue(email)

                // TODO: Set the initial family name to something more descriptive (perhaps using their last name or something?)
                self.family.child(self.store.family.id).child("name").setValue("New Family")
                //self.present(FamilyViewController() as UIViewController, animated: true, completion: nil) -> without Segue
                //self.performSegue(withIdentifier: "showFamily", sender: nil)
            }
        }
    }

}

extension RegisterViewController: GIDSignInUIDelegate {
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        RegisterViewController().dismiss(animated: false, completion: { _ in
        })
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        present(FamilyViewController() as UIViewController, animated: true, completion: nil)
    }
    
    func signIn() {
        GIDSignIn.sharedInstance().signIn()
    }
    
}
