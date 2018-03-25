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
    
    var messageItems = [[Any]]()
    
    let speechSynthesizer = AVSpeechSynthesizer()
//the pain is in your lower right abdomen and tender to the touch, you're vomiting blood, you're struggling to breath
    override func viewDidLoad() {
        messageItems = [["my stomach hurts", true], [" okay, do you feel any of the following symptoms: the pain is in your lower right abdomen and tender to the touch, you're vomiting blood, you're struggling to breath", false] ]
        
        super.viewDidLoad()
        
        // Hide lines between cells in chat table view
        self.chatTableView.delegate = self
        self.chatTableView.dataSource = self
        self.chatTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.chatTableView.rowHeight = UITableViewAutomaticDimension
        self.chatTableView.estimatedRowHeight = 140
        
        self.navigationItem.hidesBackButton = true
    
        NotificationCenter.default.addObserver(self, selector: #selector(MessageController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MessageController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func addMessage(message: String, fromUser: Bool) {
        chatTableView.beginUpdates()
        messageItems.append([message, fromUser])
        let newIndexPath = IndexPath(row: messageItems.count-1, section: 0)
        chatTableView.insertRows(at: [newIndexPath], with: UITableViewRowAnimation.left)
        chatTableView.endUpdates()
    }
    
    func speechAndText(text: String) {
        
        print("text:", text)
        addMessage(message: text, fromUser: false)
        
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
            addMessage(message: text, fromUser: true)
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
//        ChatBox.becomeFirstResponder()
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
        return messageItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatTableViewCell", for: indexPath)
        
        let messageText = messageItems[indexPath.row][0] as! String
//        cell.messageText.text = messageText
        cell.textLabel?.text = messageText
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.isUserInteractionEnabled = false
        let grayVal = CGFloat(0.85)
        cell.textLabel?.backgroundColor = UIColor(red: grayVal, green: grayVal, blue: grayVal, alpha: grayVal)
        
        if let layer = cell.textLabel?.layer {
            layer.cornerRadius = 5
            layer.masksToBounds = true
            layer.shadowOffset = .zero
            layer.shadowOpacity = 0.2
            layer.shadowRadius = 10
            layer.shadowColor = UIColor.black.cgColor
            layer.masksToBounds = false
        }

//        let messageFromUser = messageItems[indexPath.row][1] as! Bool
//        if messageFromUser {
//            cell.messageText.textAlignment = NSTextAlignment.right
//            cell.leftConstraint?.constant = 10.0
//            cell.leftConstraint?.priority = UILayoutPriority.defaultLow
//            cell.rightConstraint?.constant = 0.0
//            cell.rightConstraint?.priority = UILayoutPriority.defaultHigh
//        } else {
//            cell.messageText.textAlignment = NSTextAlignment.left
//            cell.leftConstraint?.constant = 0.0
//            cell.leftConstraint?.priority = UILayoutPriority.defaultHigh
//            cell.rightConstraint?.constant = 10.0
//            cell.rightConstraint?.priority = UILayoutPriority.defaultLow
//        }
        
        
//        cell.contentView.setNeedsLayout()
//        cell.contentView.layoutIfNeeded()
//
//        cell.layout()
//
//        cell.contentView.setNeedsLayout()
//        cell.contentView.layoutIfNeeded()
        
        return cell
    }
    
//    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return tableView.rowHeight
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
}

