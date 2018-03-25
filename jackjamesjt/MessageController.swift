//
//  ViewController.swift
//  jackjamesjt
//
//  Created by Richard James Childress on 3/24/18.
//  Copyright © 2018 Richard James Childress. All rights reserved.
//

import UIKit
import ApiAI
import AVFoundation

class MessageController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var ChatBox: UITextField!
    @IBOutlet weak var chatTableView: ChatTableView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    let soundEnabled = true
    
    var messageItems = [String]()
    
    let speechSynthesizer = AVSpeechSynthesizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide lines between cells in chat table view
        self.chatTableView.delegate = self
        self.chatTableView.dataSource = self
        self.chatTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.chatTableView.rowHeight = UITableViewAutomaticDimension
        self.chatTableView.estimatedRowHeight = 100
        
        self.navigationItem.hidesBackButton = true
    
        NotificationCenter.default.addObserver(self, selector: #selector(MessageController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MessageController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func addMessage(message: String) {
        chatTableView.beginUpdates()
        messageItems.append(message)
        let newIndexPath = IndexPath(row: messageItems.count-1, section: 0)
        chatTableView.insertRows(at: [newIndexPath], with: UITableViewRowAnimation.left)
        chatTableView.endUpdates()
    }
    
    func speechAndText(text: String) {
        
        print("text:", text)
        addMessage(message: text)
        
        if soundEnabled {
            let speechUtterance = AVSpeechUtterance(string: text)
            speechSynthesizer.speak(speechUtterance)
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
            }, completion: nil)
        }
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        let request = ApiAI.shared().textRequest()
        
        if let text = self.ChatBox.text, text != "" {
            addMessage(message: text)
            request?.query = text
        } else {
            return
        }
        
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
            if let textResponse = response.result.fulfillment.speech {
                self.speechAndText(text: textResponse)
            }
        }, failure: { (request, error) in
            print(error!)
        })
        
        ApiAI.shared().enqueue(request)
        ChatBox.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear( animated )
        ChatBox.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        adjustingHeight(show: true, notification: notification)
        // 1
        var userInfo = notification.userInfo!
        // 2
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        // 3
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        // 4
        let changeInHeight = (keyboardFrame.height + 40)
        //5
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            self.bottomConstraint.constant += changeInHeight
        })
        self.bottomConstraint.constant = keyboardFrame.height + 50
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        self.bottomConstraint.constant = 20
    }
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
        // 1
        var userInfo = notification.userInfo!
        // 2
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        // 3
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        // 4
        let changeInHeight = (keyboardFrame.height + 40) * (show ? 1 : -1)
        //5
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            self.bottomConstraint.constant += changeInHeight
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    // TableView Delegate methods for messages
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print ("rows \(messageItems.count)")
        return messageItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableView.dequeueReusableCell(withIdentifier: "chatTableViewCell", for: indexPath) as! ChatTableViewCell
        
        cell.messageText.text = messageItems[indexPath.row]
        
        return cell
    }
    
}

