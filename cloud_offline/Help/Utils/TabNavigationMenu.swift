//
//  TabNavigationMenu.swift
//  cloud_offline
//
//  Created by Macbook on 14/07/2021.
//

import Foundation
import UIKit
class TabNavigationMenu: UIView {
    var itemTapped: ((_ tab: Int) -> Void)?
    var activeItem: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
    }
    convenience init(menuItems: [TabItem], frame: CGRect) {
        self.init(frame: frame)
        for i in 0 ..< menuItems.count {
            
            let itemWidth = (self.frame.width - 45) / CGFloat(menuItems.count)
            let leadingAnchor = itemWidth * CGFloat(i)
            let itemView = self.createTabItem(item: menuItems[i])
            itemView.translatesAutoresizingMaskIntoConstraints = false
            itemView.clipsToBounds = true
            itemView.tag = i
            self.addSubview(itemView)
        
            if i == 0 {
                NSLayoutConstraint.activate([
                        itemView.heightAnchor.constraint(equalTo: self.heightAnchor , constant: -20),
                        itemView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 45),
                        itemView.topAnchor.constraint(equalTo: self.topAnchor , constant: 10),
                    ])

            }else {
                NSLayoutConstraint.activate([
                        itemView.heightAnchor.constraint(equalTo: self.heightAnchor , constant: -20),
                        itemView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingAnchor + 45),
                        itemView.topAnchor.constraint(equalTo: self.topAnchor , constant: 10),
                ])
            }

//            NSLayoutConstraint.activate([
//                    itemView.heightAnchor.constraint(equalTo: self.heightAnchor , constant: 0),
//                    itemView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingAnchor),
//                    itemView.topAnchor.constraint(equalTo: self.topAnchor , constant: 0),
//            ])
            
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.activateTab(tab: 0) // activate the first tab
        // ...
    }
    func createTabItem(item: TabItem) -> UIView {
        let tabBarItem = UIView(frame: CGRect.zero)
        let itemTitleLabel = UILabel(frame: CGRect.zero)
        let itemIconView = UIImageView(frame: CGRect.zero)
        let selectedItemView = UIImageView(frame: CGRect.zero)
        
        itemTitleLabel.text = ""
        itemTitleLabel.textAlignment = .center
        itemTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        itemTitleLabel.clipsToBounds = true
        
        
        selectedItemView.image = UIImage(named: "Vector2")
        selectedItemView.translatesAutoresizingMaskIntoConstraints = false
        selectedItemView.clipsToBounds = true
        tabBarItem.addSubview(selectedItemView)
        NSLayoutConstraint.activate([
            selectedItemView.centerXAnchor.constraint(equalTo: tabBarItem.centerXAnchor),
            selectedItemView.centerYAnchor.constraint(equalTo: tabBarItem.centerYAnchor, constant: 9),
            selectedItemView.heightAnchor.constraint(equalToConstant: 30),
            selectedItemView.widthAnchor.constraint(equalToConstant: 90)
        ])
        
        selectedItemView.layer.cornerRadius = 10
        tabBarItem.sendSubviewToBack(selectedItemView)
        
        selectedItemView.isHidden = true
        
        
        itemIconView.image = item.icon.withRenderingMode(.automatic)
        itemIconView.translatesAutoresizingMaskIntoConstraints = false
        itemIconView.clipsToBounds = true
        tabBarItem.layer.backgroundColor = UIColor.white.cgColor
        tabBarItem.addSubview(itemIconView)
        tabBarItem.addSubview(itemTitleLabel)
        tabBarItem.translatesAutoresizingMaskIntoConstraints = false
        tabBarItem.clipsToBounds = true
        NSLayoutConstraint.activate([
            itemIconView.centerXAnchor.constraint(equalTo: tabBarItem.centerXAnchor),
            itemIconView.topAnchor.constraint(equalTo: tabBarItem.topAnchor, constant: 8), // Position menu item icon 8pts from the top of it's parent view
            itemIconView.leadingAnchor.constraint(equalTo: tabBarItem.leadingAnchor, constant: 40),
            itemTitleLabel.heightAnchor.constraint(equalToConstant: 13), // Fixed height for title label
            itemTitleLabel.widthAnchor.constraint(equalTo: tabBarItem.widthAnchor), // Position label full width across tab bar item
            itemTitleLabel.topAnchor.constraint(equalTo: itemIconView.bottomAnchor, constant: 4), // Position title label 4pts below item icon
        ])
        tabBarItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap))) // Each item should be able to trigger and action on tap
        return tabBarItem
    }
    @objc func handleTap(_ sender: UIGestureRecognizer) {
        self.switchTab(from: self.activeItem, to: sender.view!.tag)
    }
    func switchTab(from: Int, to: Int) {
        self.deactivateTab(tab: from)
        self.activateTab(tab: to)
    }
    func activateTab(tab: Int) {
        let tabToActivate = self.subviews[tab]
        let borderWidth = tabToActivate.frame.size.width - 20
        let borderLayer = CALayer()
        borderLayer.backgroundColor = UIColor.orange.cgColor
        borderLayer.name = "active border"
        borderLayer.frame = CGRect(x: 20, y: 40, width: borderWidth-20, height: 2)
        
    DispatchQueue.main.async {
            UIView.animate(withDuration: 0.8, delay: 0.0, options: [.curveEaseIn, .allowUserInteraction], animations: {
                tabToActivate.layer.addSublayer(borderLayer)
                tabToActivate.setNeedsLayout()
                tabToActivate.layoutIfNeeded()
            })
            self.itemTapped?(tab)
        }
        self.activeItem = tab
    }
    func deactivateTab(tab: Int) {
        let inactiveTab = self.subviews[tab]
        let layersToRemove = inactiveTab.layer.sublayers!.filter({ $0.name == "active border" })
    DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseIn, .allowUserInteraction], animations: {
                layersToRemove.forEach({ $0.removeFromSuperlayer() })
                inactiveTab.setNeedsLayout()
                inactiveTab.layoutIfNeeded()
            })
        }
    }
}
