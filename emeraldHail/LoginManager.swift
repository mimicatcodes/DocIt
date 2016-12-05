//
//  LoginManager.swift
//  emeraldHail
//
//  Created by Tanira Wiggins on 12/5/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuthUI

// MARK: Google Sign In
class LoginManager: NSObject {
    let store = DataStore.sharedInstance
    let family = FIRDatabase.database().reference().child("family")
}

    extension LoginManager: GIDSignInDelegate {
    

        
        
        func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
            DispatchQueue.main.async {
                
                guard error == nil else { /* TODO */ return }
                
                let authentication = user.authentication
                let credential = FIRGoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!,
                                                                  accessToken: (authentication?.accessToken)!)
                
                
                
                
                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    
                    // Set the sharedInstance familyID to the current user.uid
                    
                    self.store.family.id = (user?.uid)!
                    
                  //  self.family.child(self.store.family.id)
                    
                    self.family.child((self.store.family.id)).child("email").setValue(user?.email)
                    
                    // TODO: Set the initial family name to something more descriptive (perhaps using their last name or something?)
                    self.family.child(self.store.family.id).child("name").setValue("New Family")

                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: .closeRegisterVC, object: nil)
                    }
                }
            }
        }
       
        func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
            // TODO
        }
        
        
        
    }
    
    

