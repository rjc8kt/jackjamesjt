//
//  LoginController.swift
//  jackjamesjt
//
//  Created by Richard James Childress on 3/24/18.
//  Copyright © 2018 Richard James Childress. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    @IBAction func logIn(_ sender: Any) {
        let herokuAppLink = "https://med-bot-hack-uva.herokuapp.com/callback"
        let logInLink = "https://account-sandbox.safetrek.io/authorize?client_id=m5qXF5ztOdT4cdQtUbZT2grBhF187vw6&scope=openid%20phone%20offline_access&response_type=code&redirect_uri=" + herokuAppLink
        UIApplication.shared.open(URL(string: logInLink)!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
