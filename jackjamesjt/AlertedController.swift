//
//  AlertedController.swift
//  jackjamesjt
//
//  Created by Richard James Childress on 3/25/18.
//  Copyright © 2018 Richard James Childress. All rights reserved.
//

import UIKit

class AlertedController: UIViewController {
    
    @IBOutlet weak var whoAlerted: UILabel!
    var hold:String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let vc = AlertController( nibName: "AlertController", bundle: nil )
        hold = vc.finalText
        whoAlerted.text = hold
        print( hold, "and", whoAlerted.text )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear( animated )
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setText( text:String ) {
        print( text )
        whoAlerted.text = text
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
