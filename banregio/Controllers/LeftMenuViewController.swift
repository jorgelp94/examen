//
//  LeftMenuViewController.swift
//  banregio
//
//  Created by Jorge Luis Perales on 5/21/18.
//  Copyright © 2018 Jorge Perales. All rights reserved.
//

import UIKit

enum LeftMenu: Int {
    case home = 0
    case section1
    case section2
    case section3
    case logout
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftMenuViewController: UIViewController, LeftMenuProtocol {

    @IBOutlet weak var tableView: UITableView!
    var menus = ["Home", "Sección 1", "Sección 2", "Sección 3", "Logout"]
    
    var homeViewController: UIViewController!
    var sectionOneViewController: UIViewController!
    var sectionTwoViewController: UIViewController!
    var sectionThreeViewController: UIViewController!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorColor = UIColor.clear
        let mainVC = storyboard!.instantiateViewController(withIdentifier: "HomeViewController")
        self.homeViewController = UINavigationController(rootViewController: mainVC)
        
        let sectionOneViewController = storyboard!.instantiateViewController(withIdentifier: "SectionOneViewController")
        self.sectionOneViewController = UINavigationController(rootViewController: sectionOneViewController)
        
        let sectionTwoViewController = storyboard!.instantiateViewController(withIdentifier: "SectionTwoViewController")
        self.sectionTwoViewController = UINavigationController(rootViewController: sectionTwoViewController)
        
        let sectionThreeViewController = storyboard!.instantiateViewController(withIdentifier: "SectionThreeViewController")
        self.sectionThreeViewController = UINavigationController(rootViewController: sectionThreeViewController)
        
        self.tableView.registerCellClass(MenuBaseTableViewCell.self)
        
        self.profileImage.layer.cornerRadius = self.profileImage.bounds.width/2
        self.profileImage.clipsToBounds = true
    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .home:
            self.slideMenuController()?.changeMainViewController(self.homeViewController, close: true)
        case .section1:
            self.slideMenuController()?.changeMainViewController(self.sectionOneViewController, close: true)
        case .section2:
            self.slideMenuController()?.changeMainViewController(self.sectionTwoViewController, close: true)
        case .section3:
            self.slideMenuController()?.changeMainViewController(self.sectionThreeViewController, close: true)
        case .logout:
            let login = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = login
        }
        
    }

}

extension LeftMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.item) {
            switch menu {
            case .home, .section1, .section2, .section3, .logout:
                return MenuBaseTableViewCell.height()
            }
        }
        return 0
    }
}

extension LeftMenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let menu = LeftMenu(rawValue: indexPath.item) {
            switch menu {
            case .home, .section1, .section2, .section3, .logout:
                let cell = MenuBaseTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: MenuBaseTableViewCell.identifier)
                cell.setData(menus[indexPath.row])
                if menu == .home {
                    cell.imageView?.image = UIImage(named: "profile")
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Indexpath item")
        print(indexPath.item)
        let cell = tableView.cellForRow(at: indexPath) as! MenuBaseTableViewCell
        
        if cell.backgroundColor == UIColor.clear {
            cell.setHighlighted(true, animated: true)
        } else {
            cell.setHighlighted(false, animated: false)
        }
        
        removeSelectedForEveryoneExcept(index: indexPath.row, tableView: tableView)
        
        if let menu = LeftMenu(rawValue: indexPath.item) {
            self.changeViewController(menu)
        }
    }
    
    func removeSelectedForEveryoneExcept(index: Int, tableView: UITableView) {
        for i in 0...(menus.count - 1) {
            let indPath = IndexPath(row: i, section: 0)
            if i != index {
                let cell = tableView.cellForRow(at: indPath) as! MenuBaseTableViewCell
                cell.setHighlighted(false, animated: true)
            }
        }
    }
}

extension UITableView {
    func registerCellClass(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        self.register(cellClass, forCellReuseIdentifier: identifier)
    }
}
