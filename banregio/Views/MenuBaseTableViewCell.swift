//
//  MenuBaseTableViewCell.swift
//  banregio
//
//  Created by Jorge Luis Perales on 5/21/18.
//  Copyright © 2018 Jorge Perales. All rights reserved.
//

import UIKit

class MenuBaseTableViewCell: UITableViewCell {

    class var identifier: String { return String.className(self) }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    open override func awakeFromNib() {
    }
    
    open func setup() {
    }
    
    open class func height() -> CGFloat {
        return 48
    }
    
    open func setData(_ data: Any?) {
        self.backgroundColor = UIColor.clear
        self.textLabel?.font = UIFont.systemFont(ofSize: 22.0)
        self.textLabel?.textColor = UIColor.white
        if let menuText = data as? String {
            self.textLabel?.text = "\t" + menuText
        }
    }
    
    override open func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            self.backgroundColor = ColorPalette.orange
        } else {
            self.backgroundColor = UIColor.clear
        }
    }
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
    }

}

extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
}

