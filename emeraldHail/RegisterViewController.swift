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
 // TO DO : Create a function that would prevent users from registering with google twice. if they registered they shouldn't be allowed to create an account
    
    
    // MARK: Outlets
    @IBOutlet weak var googleContainerView: UIView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var createAccount: UIButton!
    let loginManager = LoginManager()

    // MARK: Properties

    let store = DataStore.sharedInstance
    let family = FIRDatabase.database().reference().child("family")

    // MARK: Loads

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        hideKeyboardWhenTappedAround()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = loginManager

    }

    override func viewWillAppear(_ animated: Bool) {
        setupViews()
    }

    // MARK: Actions

    @IBAction func createAccountPressed(_ sender: Any) {
        register()
    }

    @IBAction func signInPressed(_ sender: Any) {
        // If on the create account screen, if they already have an account...take them to the sign in screen
        //        self.performSegue(withIdentifier: "showLogin", sender: nil)
        
        
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

                self.performSegue(withIdentifier: "showFamily", sender: nil)
            }
        }
    }

}
// MARK: - Google UI Delegate
extension RegisterViewController: GIDSignInUIDelegate {

    func configureGoogleButton() {
        let googleSignInButton = GIDSignInButton()
    
        googleSignInButton.colorScheme = .light
        googleSignInButton.style = .standard
        
        self.view.addSubview(googleContainerView)
        
        googleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        googleSignInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        googleSignInButton.topAnchor.constraint(equalTo: createAccount.bottomAnchor, constant: 10).isActive = true
        googleSignInButton.heightAnchor.constraint(equalTo: createAccount.heightAnchor).isActive = true
        googleSignInButton.widthAnchor.constraint(equalTo: createAccount.widthAnchor).isActive = true
        
        
        
        
        view.layoutIfNeeded()
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        viewController.dismiss(animated: false, completion: { _ in
        })

    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        present(viewController, animated: true, completion: nil)
    }
    
//    func signIn() {
//        GIDSignIn.sharedInstance().signIn()
//    }
    
}

