//
//  FamilyViewController.swift
//  emeraldHail
//
//   Created by Tanira Wiggins on 11/20/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FamilyViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
//    @IBOutlet weak var uploadPhotoLibraryView: UIImageView!
    @IBOutlet weak var memberProfilesView: UICollectionView!
    
    let imageSelected = UIImagePickerController()
    
    var membersInFamily = [Member]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageSelected.delegate = self
//        uploadPhotoLibraryView.image = UIImage(named: "blackfam")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        memberProfilesView.delegate = self
        memberProfilesView.dataSource = self
        
        configDatabase()
        
        memberProfilesView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.memberProfilesView.reloadData()
    }
    
//    @IBAction func uploadPhotoGesture(_ sender: UITapGestureRecognizer) {
//        let myPickerController = UIImagePickerController()
//        myPickerController.delegate = self
//        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
//        
//        
//        self.present(myPickerController, animated: true, completion: nil)
//    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return membersInFamily.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = memberProfilesView.dequeueReusableCell(withReuseIdentifier: "memberCell", for: indexPath) as! MemberCollectionViewCell
        let eachMember = membersInFamily[indexPath.row]
        cell.memberNameLabel?.text = eachMember.firstName
        EventLogics.sharedInstance.memberID = membersInFamily[indexPath.row].uniqueID
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        EventLogics.sharedInstance.memberID = membersInFamily[indexPath.row].uniqueID
        print("=============================\(EventLogics.sharedInstance.memberID)")
        print("Item at indexPath.row: \(indexPath.row) selected!")
    }
    
    
    func configDatabase() {
        
        let membersRef = FIRDatabase.database().reference().child("members")
        let familyRef = membersRef.child((FIRAuth.auth()?.currentUser?.uid)!)
        
        familyRef.observe(.value, with: { snapshot in
            
            print(snapshot)
            
            var newItem = [Member]()
            
            for item in snapshot.children {
                
                let newMember = Member(snapshot: item as! FIRDataSnapshot)
                
                newItem.append(newMember)
            }
            
            self.membersInFamily = newItem
            self.memberProfilesView.reloadData()
        })
        
    }
    
    
    
    
}
