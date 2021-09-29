//
//  SettingViewController.swift
//  cloud_offline
//
//  Created by Macbook on 14/07/2021.
//

import UIKit

class SettingViewController: UIViewController {
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var termBtn: UIButton!
    @IBOutlet weak var privacyBtn: UIButton!
    @IBOutlet weak var rateBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        shareBtn.layer.cornerRadius = 15
        termBtn.layer.cornerRadius = 15
        privacyBtn.layer.cornerRadius = 15
        rateBtn.layer.cornerRadius = 15
    }
    @IBAction func termOfService(_ sender: Any) {
    }
    
    @IBAction func privacyBtn(_ sender: Any) {
    }
    @IBAction func shareWithFr(_ sender: Any) {
    }
    @IBAction func rateApp(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
