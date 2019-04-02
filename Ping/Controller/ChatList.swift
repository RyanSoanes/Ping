//
//  ChatList.swift
//  Ping
//
//  Created by Ryan Soanes on 11/02/2019.
//  Copyright © 2019 LionStone. All rights reserved.
//

import UIKit
import Firebase

class ChatList: UIViewController, UITableViewDelegate, UITableViewDataSource, ViewControllerBDelegate {
    
    @IBOutlet var chatsTableView: UITableView!
    @IBOutlet var topNameLabel: UILabel!
    var chats = 1
    var currentUser: UserStored?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        chatsTableView.delegate = self //sets self as delegate for table view
        chatsTableView.dataSource = self //sets self as data source for table view
        chatsTableView.register(UINib(nibName: "CustomChatCell", bundle: nil), forCellReuseIdentifier: "customChatCell") //register xib file to chat table view
        retrieveUsername()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMessages" {
            let secondView = segue.destination as! MessageView
            secondView.currentUser = currentUser
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customChatCell", for: indexPath) as! CustomChatCell //initiate custom cell for chat table view
        let username = ["TestUser"] //declared array for test data
        cell.chatUsername.text = username[indexPath.row] //alter chatUsername element with test data for username
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //returns number of cells wanted on tableview
        return chats
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(currentUser?.uid)
        segueToMessages()
    }
    
    @IBAction func addConvo(_ sender: UIButton) {
        let sb = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let contacts = sb.instantiateViewController(withIdentifier: "Contacts View") as! ContactsView
        contacts.delegate = self
        self.present(contacts, animated: true, completion: nil)
    }
    
    func getDataBack(selectedUser: UserStored) {
        currentUser = selectedUser
    }
    
    func retrieveUsername() {
        let currentUser = Auth.auth().currentUser!.uid
        var databaseReference: DatabaseReference!
        databaseReference = Database.database().reference()
        databaseReference.child("users").child(currentUser).observeSingleEvent(of: .value) { (snapshot) in
            if let name = snapshot.value as? [String: AnyObject] {
                self.topNameLabel.text = name["username"] as? String
            }
        }
    }
    
    func segueToMessages() {
        self.performSegue(withIdentifier: "toMessages", sender: self)
    }
    
}
