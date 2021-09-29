//
//  RoundedTabBarController.swift
//  cloud_offline
//
//  Created by Macbook on 13/07/2021.
//

import Foundation
import UIKit

class RoundedTabBarController: UITabBarController {

    let tabView = UIView()
    var customTabBar: TabNavigationMenu!
    var tabBarHeight: CGFloat = 67.0
    override func viewDidLoad() {
        super.viewDidLoad()
//        setTupTabBar()
        self.loadTabBar()
        delegate = self
        self.view.backgroundColor = UIColor.white

    }
    fileprivate func setTupTabBar(){
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: CGRect(x: 30, y: tabBar.bounds.minY + 5, width: tabBar.bounds.width - 60, height: tabBar.bounds.height + 10), cornerRadius: (tabBar.frame.width/2)).cgPath
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        layer.shadowRadius = 25.0
        layer.shadowOpacity = 0.3
        layer.borderWidth = 1.0
        layer.opacity = 1.0
        layer.isHidden = false
        layer.masksToBounds = false
        layer.fillColor = UIColor.white.cgColor
    //    tabBar.layer.insertSublayer(layer, at: 0)
//        tabBar.isHidden = true
        let tabView = UIView(frame: CGRect(x: 0, y: self.view.frame.height-120, width: tabBar.bounds.width - 60, height: tabBar.bounds.height + 10))
        tabView.layer.insertSublayer(layer, at: 0)
        self.view.addSubview(tabView)
    }
    func loadTabBar() {
        let tabItems: [TabItem] = [.online,.local,.setting]
        setupCustomTabMenu(tabItems) { (controllers) in
            print(controllers)
            self.viewControllers = controllers
            
        }
        self.selectedIndex = 0
    }
    func setupCustomTabMenu(_ menuItems: [TabItem], completion: @escaping ([UIViewController]) -> Void) {
        
        //MARK: BONUS
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: CGRect(x: 30, y: tabBar.bounds.minY + 5, width: tabBar.bounds.width - 60, height: tabBar.bounds.height + 10), cornerRadius: (tabBar.frame.width/2)).cgPath
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        layer.shadowRadius = 25.0
        layer.shadowOpacity = 0.3
        layer.borderWidth = 1.0
        layer.opacity = 1.0
        layer.isHidden = false
        layer.masksToBounds = false
        layer.fillColor = UIColor.white.cgColor
        //
        
        let frame = CGRect(x: 0, y: self.view.frame.height-120, width: tabBar.bounds.width - 60, height: tabBar.bounds.height )
        var controllers = [UIViewController]()
        
        self.customTabBar = TabNavigationMenu(menuItems: menuItems, frame: frame )
        // hide the tab bar
        tabBar.isHidden = true
        self.customTabBar.translatesAutoresizingMaskIntoConstraints = false
        self.customTabBar.clipsToBounds = true
        self.customTabBar.itemTapped = self.changeTab
        // Add it to the view

        customTabBar.layer.insertSublayer(layer, at: 0)
        self.view.addSubview(customTabBar)
        
        
//         Add positioning constraints to place the nav menu right where the tab bar should be
        NSLayoutConstraint.activate([
            self.customTabBar.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor,constant: 0),
            self.customTabBar.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor,constant: 20),
            self.customTabBar.widthAnchor.constraint(equalToConstant: self.view.frame.width ),
            self.customTabBar.heightAnchor.constraint(equalToConstant: tabBarHeight), // Fixed height for nav menu
//            self.customTabBar.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor,constant: 50)
            self.customTabBar.bottomAnchor.constraint(equalTo: tabBar.topAnchor,constant: 30)
        ])
        

        for i in 0 ..< menuItems.count {
            controllers.append(menuItems[i].viewController) // we fetch the matching view controller and append here
        }
        self.view.layoutIfNeeded() // important step
        completion(controllers) // setup complete. handoff here
    }
    func changeTab(tab: Int) {
        self.selectedIndex = tab
    }
    
}

enum TabItem: String {
    case online = "O"
    case local = "L"
    case setting = "S"
    var viewController: UIViewController {
            switch self {
            case .online:
                return CloudViewController()
            case .local:
                return LocalViewController()
            case .setting:
                return SettingViewController()

            }
        }
    var icon: UIImage {
        switch self {
        case .online:
            return UIImage(named: "Vector1")!
        case .local:
            return UIImage(named: "Vector3")!
        case .setting:
            return UIImage(named: "Group 59")!
        }
        
    }
    var displayTitle: String {
            return self.rawValue.capitalized(with: nil)
    }
}

extension RoundedTabBarController : UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MyTransition(viewControllers: tabBarController.viewControllers)
    }
}

class MyTransition: NSObject, UIViewControllerAnimatedTransitioning {

    let viewControllers: [UIViewController]?
    let transitionDuration: Double = 0.25

    init(viewControllers: [UIViewController]?) {
        self.viewControllers = viewControllers
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(transitionDuration)
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let fromView = fromVC.view,
            let fromIndex = getIndex(forViewController: fromVC),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let toView = toVC.view,
            let toIndex = getIndex(forViewController: toVC)
            else {
                transitionContext.completeTransition(false)
                return
        }

        let frame = transitionContext.initialFrame(for: fromVC)
        var fromFrameEnd = frame
        var toFrameStart = frame
        fromFrameEnd.origin.x = toIndex > fromIndex ? frame.origin.x - frame.width : frame.origin.x + frame.width
        toFrameStart.origin.x = toIndex > fromIndex ? frame.origin.x + frame.width : frame.origin.x - frame.width
        toView.frame = toFrameStart

        DispatchQueue.main.async {
            transitionContext.containerView.addSubview(toView)
            UIView.animate(withDuration: self.transitionDuration, animations: {
                fromView.frame = fromFrameEnd
                toView.frame = frame
            }, completion: {success in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(success)
            })
        }
    }

    func getIndex(forViewController vc: UIViewController) -> Int? {
        guard let vcs = self.viewControllers else { return nil }
        for (index, thisVC) in vcs.enumerated() {
            if thisVC == vc { return index }
        }
        return nil
    }
}
