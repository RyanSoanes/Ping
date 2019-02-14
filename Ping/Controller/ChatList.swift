//
//  ChatList.swift
//  Ping
//
//  Created by Ryan Soanes on 11/02/2019.
//  Copyright © 2019 LionStone. All rights reserved.
//

import UIKit

class ChatList: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var chatsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        chatsTableView.delegate = self //sets self as delegate for table view
        chatsTableView.dataSource = self //sets self as data source for table view
        chatsTableView.register(UINib(nibName: "CustomChatCell", bundle: nil), forCellReuseIdentifier: "customChatCell") //register xib file to chat table view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customChatCell", for: indexPath) as! CustomChatCell //initiate custom cell for chat table view
        let username = ["Username1", "Username2", "Username3"]
        cell.chatUsername.text = username[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
}
