//
//  ViewByDialogViewController.swift
//  cloud_offline
//
//  Created by ThanhThanh on 12/08/2021.
//

import UIKit

class ViewByDialogViewController: UIViewController  {

    //MARK: -Properties
    
    var flag : String = ""
    var songs = RealmService.shared.load(listOf: Song.self)
    var type : Int = 0
    //MARK: -Closure
    
    var onSubmitSortByButton : (() -> Void)?
    var onSubmitViewByButton : (() -> Void)?
    
    //MARK: -UI Components
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGradientBackgroundBtn(colorLeft: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), colorRight: #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1))
        

        let nib = UINib(nibName: "DialogTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DialogTableViewCell")
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if flag == "ViewBy"{
            titleLabel.text = "View by"
        }
        else {
            titleLabel.text = "Sort By"
        }
        
    }
    
    @IBAction func onSubmitBtn(_ sender: Any) {
        if flag == "SortBy"{
            onSubmitSortByButton!()
        }
        if flag == "ViewBy"{
            onSubmitViewByButton!()
        }
        dismiss(animated: true, completion: nil)
    }
    func setGradientBackgroundBtn(colorLeft: UIColor, colorRight: UIColor) {
        submitBtn.layer.cornerRadius = 16
        submitBtn.clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorRight.cgColor, colorLeft.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = submitBtn.layer.bounds
        submitBtn.layer.insertSublayer(gradientLayer, at: 0)
       
    }
    
}
extension ViewByDialogViewController : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if flag == "ViewBy"{
            if type == 0 {
                return 3
            }
            else {
                return 2
            }
            
        }
        else {
            return 4
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DialogTableViewCell") as! DialogTableViewCell
        if flag == "ViewBy"{
            if type == 0 {
                UserDefaults.standard.set(indexPath.item, forKey: "AudioViewBy")
            }
            else {
                UserDefaults.standard.set(indexPath.item, forKey: "VideoViewBy")
            }
           
        }
        else {
            if type == 0 {
                UserDefaults.standard.set(indexPath.item, forKey: "AudioSortBy")
            }
            else {
                print("ViewByDialogVC\(indexPath.item)")
                UserDefaults.standard.set(indexPath.item, forKey: "VideoSortBy")
            }
            
        }
        cell.checkBox.image = UIImage(named: "check")
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DialogTableViewCell") as! DialogTableViewCell
        if flag == "SortBy" {
            let listTitle = ["A to Z","Z to A","Lastest","Oldest"]
            if type == 0 {
                if UserDefaults.standard.integer(forKey: "AudioSortBy") == indexPath.item {
                    cell.checkBox.image = UIImage(named: "check")
                }
                else {
                    cell.checkBox.image = UIImage(named: "Ellipse 61")
                    
                }
            }
            else {
                if UserDefaults.standard.integer(forKey: "VideoSortBy") == indexPath.item {
                    cell.checkBox.image = UIImage(named: "check")
                }
                else {
                    cell.checkBox.image = UIImage(named: "Ellipse 61")
                    
                }
            }
            
            cell.leftLbl.text = listTitle[indexPath.row]
            cell.tintColor = .orange
        }
        else {
            if type == 0 {
                let listTitle = ["Track","Playlist","Album"]
                if UserDefaults.standard.integer(forKey: "AudioViewBy") == indexPath.item {
                    cell.checkBox.image = UIImage(named: "check")

                }
                else {
                    cell.checkBox.image = UIImage(named: "Ellipse 61")

                }
                cell.leftLbl.text = listTitle[indexPath.row]
                cell.tintColor = .orange
            }
            else {
                let listTitle = ["Video","Playlist"]
                if UserDefaults.standard.integer(forKey: "VideoViewBy") == indexPath.item {
                    cell.checkBox.image = UIImage(named: "check")
                }
                else {
                    cell.checkBox.image = UIImage(named: "Ellipse 61")

                }
                cell.leftLbl.text = listTitle[indexPath.row]
                cell.tintColor = .orange
            }
            
        }
        
        return cell
    }
}
