//
//  FamilyViewController.swift
//  emeraldHail
//
//  Created by Tanira Wiggins on 11/20/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage


class FamilyViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: Properties
    let store = Logics.sharedInstance
    let imageSelected = UIImagePickerController()
    var membersInFamily = [Member]()
    var family = [Family]()
    
    
    // MARK: Outlets
    @IBOutlet weak var familyName: UIButton!
    @IBOutlet weak var familyNameLabel: UILabel!
    @IBOutlet weak var memberProfilesView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Inside Family VC, the familyID is: \(store.familyID)")
        
        hideKeyboardWhenTappedAround()
        getFamilyID()
        
        imageSelected.delegate = self
        memberProfilesView.delegate = self
        memberProfilesView.dataSource = self
        
        configDatabaseFamily()
        configDatabaseMember()
        
        memberProfilesView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.memberProfilesView.reloadData()
    }
    
    // TODO: Can anyone tell me what this is doing? -Henry Is giving format to the text next to the < sign
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backButton = UIBarButtonItem()
        backButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Arial", size: 15)!], for: UIControlState.normal)
        navigationItem.backBarButtonItem = backButton
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    // MARK: Actions
    @IBAction func changeFamilyName(_ sender: UIButton) {
        changeFamilyName()
    }
    
    // COLLECTION VIEW METHODS
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return membersInFamily.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = memberProfilesView.dequeueReusableCell(withReuseIdentifier: "memberCell", for: indexPath) as! MemberCollectionViewCell
        let member = membersInFamily[indexPath.row]
        cell.memberNameLabel?.text = member.firstName
        cell.profileImageView.image = UIImage(named: "kid_silhouette")
        cell.profileImageView.contentMode = .scaleAspectFill
        cell.profileImageView.setRounded()
        
//        if let profileImg = member.profileImage {
        
            let profileImgUrl = URL(string: member.profileImage)
            cell.profileImageView.sd_setImage(with: profileImgUrl)
            
//        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        store.memberID = membersInFamily[indexPath.row].uniqueID
    }
    
    // MARK: Functions
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FamilyViewController.dismissKeyboardView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboardView() {
        view.endEditing(true)
    }
    
    func getFamilyID() {
        store.familyID = (FIRAuth.auth()?.currentUser?.uid)!
    }
    
    // TODO: Rethink some of the variable names here and in configDatabaseFamily for clarity
    func configDatabaseMember() {
        let membersRef = FIRDatabase.database().reference().child("members")
        let familyRef = membersRef.child(store.familyID)
        
        familyRef.observe(.value, with: { snapshot in
            var newItem = [Member]()
            
            for item in snapshot.children {
                let newMember = Member(snapshot: item as! FIRDataSnapshot)
                newItem.append(newMember)
            }
            
            self.membersInFamily = newItem
            self.memberProfilesView.reloadData()
        })
    }
    
    // TODO: Rethink some of the variable names here for clarity
    func configDatabaseFamily() {
        let membersRef = FIRDatabase.database().reference().child("family")
        let familyRef = membersRef.child(store.familyID)
        
        familyRef.observe(.value, with: { snapshot in
            var name = snapshot.value as! [String:Any]
            
            self.familyNameLabel.text = name["name"] as? String
        })
    }
    
    func changeFamilyName() {
        var nameTextField: UITextField?
        
        let alertController = UIAlertController(title: nil, message: "Change your family name", preferredStyle: .alert)
        let save = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            guard let name = nameTextField?.text, name != "" else { return }
            let databaseEventsRef = FIRDatabase.database().reference().child("family").child(self.store.familyID)
            
            // TODO: We shoul be handling all the errors properly
            databaseEventsRef.updateChildValues(["name": name], withCompletionBlock: { (error, dataRef) in
            })
            
            print("Save Button Pressed")
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel Button Pressed")
        }
        
        alertController.addAction(save)
        alertController.addAction(cancel)
        alertController.addTextField { (textField) -> Void in
            nameTextField = textField
        }
        
        present(alertController, animated: true, completion: nil)
    }
}

class MemberCollectionViewCell: UICollectionViewCell {
    
    // OUTLETS
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
}
