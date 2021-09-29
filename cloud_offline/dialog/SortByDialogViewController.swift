//
//  SortByDialogViewController.swift
//  cloud_offline
//
//  Created by ThanhThanh on 23/08/2021.
//

import UIKit

class SortByDialogViewController: UIViewController {
//MARK: - UI Components
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortBtn: UIButton!
    //MARK: - Properties
    var onSubmitSortByButton : (() -> Void)?
    var viewBy : AudioViewBy = .album
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackgroundBtn(colorLeft: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), colorRight: #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1))
        let nib = UINib(nibName: "DialogTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DialogTableViewCell")
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    fileprivate func setGradientBackgroundBtn(colorLeft: UIColor, colorRight: UIColor) {
        sortBtn.layer.cornerRadius = 16
        sortBtn.clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorRight.cgColor, colorLeft.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = sortBtn.layer.bounds
        sortBtn.layer.insertSublayer(gradientLayer, at: 0)
       
    }
    

    @IBAction func submit(_ sender: Any) {
        onSubmitSortByButton!()
        dismiss(animated: true, completion: nil)
    }


}
extension SortByDialogViewController : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DialogTableViewCell") as! DialogTableViewCell
        let titleLbl = ["A to Z","Z to A"]
        if viewBy == .album {
            if UserDefaults.standard.integer(forKey: "SortByAlbum") == indexPath.item {
                cell.checkBox.image = UIImage(named: "check")
            }
            else {
                cell.checkBox.image = UIImage(named: "Ellipse 61")
                
            }
        }
        else {
            if UserDefaults.standard.integer(forKey: "SortByPlaylist") == indexPath.item {
                cell.checkBox.image = UIImage(named: "check")
            }
            else {
                cell.checkBox.image = UIImage(named: "Ellipse 61")
                
            }
        }
        
        cell.leftLbl.text = titleLbl[indexPath.item]
        cell.tintColor = .orange

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DialogTableViewCell") as! DialogTableViewCell
        if viewBy == .album{
            UserDefaults.standard.set(indexPath.item, forKey: "SortByAlbum")
        }
        else {
            UserDefaults.standard.set(indexPath.item, forKey: "SortByPlaylist")
        }
        cell.checkBox.image = UIImage(named: "check")
        tableView.reloadData()
    }
}
