//
//  LocalViewController.swift
//  cloud_offline
//
//  Created by Macbook on 14/07/2021.
//
//
import UIKit
import Tabman
import Pageboy


class LocalViewController : TabmanViewController , TMBarDataSource {
    //MARK: -UI components
    @IBOutlet weak var tabView: UIView!
    
    
    //MARK: -Properties
   
//    private var viewControllers = [LocalVideoViewController(),LocalAudioViewController()]
    static let videoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LocalVideoViewController") as! LocalVideoViewController
    static let audioVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LocalAudioViewController") as! LocalAudioViewController
    private var viewControllers = [videoVC,audioVC]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        // Create bar
        createBar()
    }

    @IBAction func search(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        self.present(vc, animated: true, completion: nil)
        
    }
    
    fileprivate func createBar(){
        let bar = TMBar.ButtonBar()
        bar.backgroundView.style = .blur(style: .light)
        bar.largeContentTitle = "Local"
        bar.layout.transitionStyle = .snap // Customize
        // Add to view
        bar.buttons.customize { (button) in
            button.tintColor = .gray
            button.selectedTintColor = .orange
            button.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 30)
        }
        bar.tintColor = .orange
        bar.backgroundColor = .white
        bar.indicator.tintColor = .orange
        addBar(bar, dataSource: self, at: .custom(view: tabView, layout: nil))
        
    }


}
extension LocalViewController : PageboyViewControllerDataSource {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
            return viewControllers.count
        }

    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return self.viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }

    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        var title = ""
        if index == 0 {
            title = "Video"
        }
        else {
            title = "Audio"
        }
        
        return TMBarItem(title: title)
    }
}

