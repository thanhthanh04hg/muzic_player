//
//  TabBarViewController.swift
//  cloud_offline
//
//  Created by Macbook on 15/07/2021.
//

import UIKit

class TabBarViewController: UIViewController {

    @IBOutlet var tabView: UIView!
    var selectedIndex: Int = 1
    var previousIndex: Int = 0
    var itemTapped: ((_ tab: Int) -> Void)?
    var activeItem: Int = 0
    @IBOutlet var stackView: UIStackView!
    var viewControllers = [UIViewController]()
    let listImage = ["Vector1","Vector3","Group 59"]
    @IBOutlet var buttons:[UIButton]!
    var footerHeight: CGFloat = 50
    
    static let firstVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CloudViewController") as! CloudViewController
    static let secondVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LocalViewController") as! LocalViewController
    static let thirdVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        tabView.layer.cornerRadius = 15
        tabView.layer.shadowColor = UIColor.lightGray.cgColor
        tabView.layer.shadowOpacity = 1
        tabView.layer.shadowOffset = .zero
        tabView.layer.shadowRadius = 10
//        tabView.layer.shadowPath = UIBezierPath(rect: tabView.bounds).cgPath
        tabView.layer.shouldRasterize = true
        
        
        viewControllers.append(TabBarViewController.firstVC)
        viewControllers.append(TabBarViewController.secondVC)
        viewControllers.append(TabBarViewController.thirdVC)
        buttons[selectedIndex].isSelected = true
        activateTab(tab: 1)
        changeViewController(buttons[selectedIndex])
        
        
//        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("todos.txt")
        
    }
    
    @IBAction func changeViewController(_ sender: UIButton) {
        buttons[previousIndex].isSelected = false
        let previousVC = viewControllers[previousIndex]
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        sender.isSelected = true
        
        let vc = viewControllers[selectedIndex]
        vc.view.frame = UIApplication.shared.windows[0].frame
        vc.didMove(toParent: self)
        self.addChild(vc)
        self.view.addSubview(vc.view)
        self.view.bringSubviewToFront(tabView)
        tabView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
    }
    @IBAction func onDisplayCloudVC(_ sender: UIButton) {
        previousIndex = selectedIndex
        selectedIndex = 0
        changeViewController(buttons[selectedIndex])
        switchTab(from: previousIndex, to: selectedIndex)
        
    }
    
    @IBAction func onDisplayLocalVC(_ sender: UIButton) {
        previousIndex = selectedIndex
        selectedIndex = 1
        changeViewController(buttons[selectedIndex])
        switchTab(from: previousIndex, to: selectedIndex)
    }
    
    @IBAction func onDisplaySetVC(_ sender: UIButton) {
        previousIndex = selectedIndex
        selectedIndex = 2
        changeViewController(buttons[selectedIndex])
        switchTab(from: previousIndex, to: selectedIndex)

    }
    func setColorForButton(sender : UIButton , flag : Bool){
        let origImage = UIImage(named: listImage[activeItem])
        let tintedImage = UIImage(named: "\(listImage[activeItem]).fill")
        
        if flag == true {
            sender.setImage(tintedImage, for: .normal)
           
        }
        else {
            sender.setImage(origImage, for: .normal)
        }
    }
    
}
extension TabBarViewController {
    func activateTab(tab: Int) {
        let tabToActivate = self.buttons[tab]
        let borderLayer = CALayer()
        borderLayer.backgroundColor = UIColor.orange.cgColor
        borderLayer.name = "active border"
        borderLayer.frame = CGRect(x: 25, y: 60 , width: 60, height: 2)
        
    DispatchQueue.main.async {
            UIView.animate(withDuration: 0.8, delay: 0.0, options: [.curveEaseIn, .allowUserInteraction], animations: {
                tabToActivate.layer.addSublayer(borderLayer)
                tabToActivate.setNeedsLayout()
                tabToActivate.layoutIfNeeded()
            })
            self.itemTapped?(tab)
        }
        self.activeItem = tab
        setColorForButton(sender: buttons[tab], flag: true)
    }
    func deactivateTab(tab: Int) {
        let inactiveTab = self.buttons[tab]
//        let layersToRemove = inactiveTab.layer.sublayers!.filter({ $0.name == "active border" })
        guard let layersToRemove = inactiveTab.layer.sublayers?.filter({ $0.name == "active border" }) else {
            return
        }
//        let layersToRemove = inactiveTab.layer.sublayers!.filter({ $0.name == "active border" })
    DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseIn, .allowUserInteraction], animations: {
                layersToRemove.forEach({ $0.removeFromSuperlayer() })
                inactiveTab.setNeedsLayout()
                inactiveTab.layoutIfNeeded()
            })
        }
        setColorForButton(sender: buttons[tab], flag: false)
    }
    func switchTab(from: Int, to: Int) {
        self.deactivateTab(tab: from)
        self.activateTab(tab: to)
    }

    func hideHeader() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.tabView.frame = CGRect(x: self.tabView.frame.origin.x, y: (self.view.frame.height + self.view.safeAreaInsets.bottom + 16), width: self.tabView.frame.width, height: self.footerHeight)
        })
    }
    
    func showHeader() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.tabView.frame = CGRect(x: self.tabView.frame.origin.x, y: self.view.frame.height - (self.footerHeight + self.view.safeAreaInsets.bottom + 16), width: self.tabView.frame.width, height: self.footerHeight)
        })
    }
}


