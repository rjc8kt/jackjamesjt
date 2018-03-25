//
//  LoginController.swift
//  jackjamesjt
//
//  Created by Richard James Childress on 3/24/18.
//  Copyright © 2018 Richard James Childress. All rights reserved.
//

import UIKit
import CoreData

class LoginController: UIViewController {

    @IBAction func logIn(_ sender: Any) {
        let herokuAppLink = "https://med-bot-hack-uva.herokuapp.com/callback"
        let logInLink = "https://account-sandbox.safetrek.io/authorize?client_id=m5qXF5ztOdT4cdQtUbZT2grBhF187vw6&scope=openid%20phone%20offline_access&response_type=code&redirect_uri=" + herokuAppLink
        UIApplication.shared.open(URL(string: logInLink)!)
    }
    override func viewDidLoad() {
        // CORE DATA
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Tokens")
        
        do {
            let results = try managedContext.fetch( fetchRequest )
            if ( results.count > 0 ) {
                let latest = results[results.count - 1]
                print("latest: \(latest.value(forKeyPath: "refreshToken"))")
                
                if ( latest.value(forKey: "refreshToken" ) == nil ) {
                    super.viewDidLoad()
                    return
                }
                
                let latrefToken = latest.value(forKeyPath: "refreshToken") as! String
                print( latrefToken )
                let lataccToken = latest.value(forKeyPath: "accessToken") as! String
                
                print("found refresh \(latrefToken) and acc \(lataccToken)")
                
                if ( lataccToken != "" ) {
                    let viewController: UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "MessageController")
                    self.navigationController?.pushViewController(viewController, animated: false)
                }
            }
        } catch {
            print( "Could not fetch." )
        }
        // END OF CORE DATA
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
