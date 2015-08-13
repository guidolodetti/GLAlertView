//
//  GLAlertView.swift
//
//  Created by Guido Lodetti on 12/08/15.
//  Copyright (c) 2015 Guido Lodetti. All rights reserved.
//

import UIKit

class GLAlertView: NSObject {
    
    /* CUSTOM SETUP */
    let bgColor = UIColor(white: 0.0, alpha: 0.3)
    let mainViewBgColor = UIColor(white: 0.0, alpha: 1.0)
    let separatorColor = UIColor(white: 1.0, alpha: 0.3)
    let titleTextColor = UIColor.whiteColor()
    let messageTextColor = UIColor.whiteColor()
    let buttonTextColor = UIColor.whiteColor()
    let titleTextFont = UIFont(name: "FuturaStd-Heavy", size: 12)!
    let messageTextFont = UIFont(name: "FuturaStd-Medium", size: 14)!
    let otherButtonFont = UIFont(name: "FuturaStd-Heavy", size: 12)!
    let cancelButtonFont = UIFont(name: "FuturaStd-Medium", size: 12)!
    /* END SETUP */
    
    
    private var xoAssociationKey: UInt8 = 0
    
    private var title : String!
    private var message : String?
    private var cancelButtonTitle : String?
    private var otherButtonTitles : [String]?
    private var blackView : UIView?
    private var mainView : UIView?
    private var newWindow : UIWindow?
    private var completition : ((alertView:GLAlertView, buttonIndex: Int) -> Void)?
    private var cancelButtonIndexVar : Int?
    
    var cancelButtonIndex : Int {
        if self.cancelButtonIndexVar != nil {
            return self.cancelButtonIndexVar!
        } else {
            return -1
        }
    }
    
    init(title: String!, message: String?, cancelButtonTitle: String?, otherButtonTitles: [String]?) {
        super.init()
        self.title = title
        self.message = message
        self.cancelButtonTitle = cancelButtonTitle
        self.otherButtonTitles = otherButtonTitles
        objc_setAssociatedObject(self, &xoAssociationKey, self, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
    }
    
    func show(completition:((alertView:GLAlertView, buttonIndex: Int) -> Void)?) {
        self.completition = completition
        // NEW WINDOW
        let window = UIApplication.sharedApplication().windows[0] as! UIWindow
        newWindow = UIWindow(frame: window.frame)
        newWindow!.windowLevel = UIWindowLevelAlert;
        newWindow!.makeKeyAndVisible()
        // NEW BACKGROUND VIEW
        blackView = UIView(frame: CGRectZero)
        blackView!.setTranslatesAutoresizingMaskIntoConstraints(false)
        blackView!.backgroundColor = bgColor
        blackView!.alpha = 0.0
        // SETUP BG VIEW DIMENSIONS
        newWindow!.addSubview(blackView!)
        newWindow!.addConstraint(NSLayoutConstraint(item: blackView!, attribute: .Width, relatedBy: .Equal, toItem: newWindow!, attribute: .Width, multiplier: 1.0, constant: 0.0))
        newWindow!.addConstraint(NSLayoutConstraint(item: blackView!, attribute: .Height, relatedBy: .Equal, toItem: newWindow!, attribute: .Height, multiplier: 1.0, constant: 0.0))
        // NEW MAIN VIEW
        self.setupMainView()
        mainView!.transform = CGAffineTransformMakeScale(0.01, 0.01);
        newWindow!.addSubview(mainView!)
        newWindow!.addConstraint(NSLayoutConstraint(item: mainView!, attribute: .CenterX, relatedBy: .Equal, toItem: newWindow!, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        newWindow!.addConstraint(NSLayoutConstraint(item: mainView!, attribute: .CenterY, relatedBy: .Equal, toItem: newWindow!, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        newWindow!.addConstraint(NSLayoutConstraint(item: mainView!, attribute: .Width, relatedBy: .Equal, toItem: newWindow!, attribute: .Width, multiplier: 0.8, constant: 0.0))
        // SHOW BG VIEW WITH ANIMATION
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.blackView!.alpha = 1.0
            }, completion: nil)
        // SHOW MAIN VIEW WITH ANIMATION
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.mainView!.transform = CGAffineTransformIdentity;
            }, completion: nil)
    }
    
    func setupMainView() {
        mainView = UIView(frame: CGRectZero)
        mainView!.setTranslatesAutoresizingMaskIntoConstraints(false)
        mainView!.backgroundColor = mainViewBgColor
        mainView!.clipsToBounds = false
        mainView!.layer.shadowColor = UIColor.blackColor().CGColor
        mainView!.layer.shadowOpacity = 0.9
        mainView!.layer.shadowOffset = CGSizeMake(0, 0)
        mainView!.layer.shadowRadius = 6.0
        // INSERT TITLE
        let titleLabel = UILabel()
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleLabel.text = self.title.uppercaseString
        titleLabel.numberOfLines = 0
        titleLabel.textColor = titleTextColor
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = titleTextFont
        mainView!.addSubview(titleLabel)
        mainView!.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Left, relatedBy: .Equal, toItem: mainView!, attribute: .Left, multiplier: 1.0, constant: 10.0))
        mainView!.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Right, relatedBy: .Equal, toItem: mainView!, attribute: .Right, multiplier: 1.0, constant: -10.0))
        mainView!.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Top, relatedBy: .Equal, toItem: mainView!, attribute: .Top, multiplier: 1.0, constant: 20.0))
        // INSERT MESSAGE IF PRESENT
        let messageLabel : UILabel!
        if let message = self.message {
            messageLabel = UILabel()
            messageLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
            messageLabel.text = message
            messageLabel.numberOfLines = 0
            messageLabel.textColor = messageTextColor
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.font = messageTextFont
            mainView!.addSubview(messageLabel)
            mainView!.addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .Left, relatedBy: .Equal, toItem: mainView!, attribute: .Left, multiplier: 1.0, constant: 10.0))
            mainView!.addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .Right, relatedBy: .Equal, toItem: mainView!, attribute: .Right, multiplier: 1.0, constant: -10.0))
            mainView!.addConstraint(NSLayoutConstraint(item: messageLabel, attribute: .Top, relatedBy: .Equal, toItem: titleLabel, attribute: .Bottom, multiplier: 1.0, constant: 20.0))
        } else {
            messageLabel = nil
        }
        // INSERT SEPARATION BAR
        let separatorView = UIView(frame: CGRectZero)
        separatorView.setTranslatesAutoresizingMaskIntoConstraints(false)
        separatorView.backgroundColor = separatorColor
        mainView!.addSubview(separatorView)
        separatorView.addConstraint(NSLayoutConstraint(item: separatorView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.5))
        mainView!.addConstraint(NSLayoutConstraint(item: separatorView, attribute: .Left, relatedBy: .Equal, toItem: mainView!, attribute: .Left, multiplier: 1.0, constant: 0))
        mainView!.addConstraint(NSLayoutConstraint(item: separatorView, attribute: .Right, relatedBy: .Equal, toItem: mainView!, attribute: .Right, multiplier: 1.0, constant: 0))
        if messageLabel != nil {
            mainView!.addConstraint(NSLayoutConstraint(item: separatorView, attribute: .Top, relatedBy: .Equal, toItem: messageLabel, attribute: .Bottom, multiplier: 1.0, constant: 20.0))
        } else {
            mainView!.addConstraint(NSLayoutConstraint(item: separatorView, attribute: .Top, relatedBy: .Equal, toItem: titleLabel, attribute: .Bottom, multiplier: 1.0, constant: 20.0))
        }
        // INSER BUTTON CONTAINER
        let buttonContainer = UIView()
        buttonContainer.setTranslatesAutoresizingMaskIntoConstraints(false)
        buttonContainer.backgroundColor = UIColor.clearColor()
        mainView!.addSubview(buttonContainer)
        buttonContainer.addConstraint(NSLayoutConstraint(item: buttonContainer, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 44.0))
        mainView!.addConstraint(NSLayoutConstraint(item: buttonContainer, attribute: .Top, relatedBy: .Equal, toItem: separatorView, attribute: .Bottom, multiplier: 1.0, constant: 0))
        mainView!.addConstraint(NSLayoutConstraint(item: buttonContainer, attribute: .Left, relatedBy: .Equal, toItem: mainView!, attribute: .Left, multiplier: 1.0, constant: 0))
        mainView!.addConstraint(NSLayoutConstraint(item: buttonContainer, attribute: .Right, relatedBy: .Equal, toItem: mainView!, attribute: .Right, multiplier: 1.0, constant: 0))
        mainView!.addConstraint(NSLayoutConstraint(item: buttonContainer, attribute: .Bottom, relatedBy: .Equal, toItem: mainView!, attribute: .Bottom, multiplier: 1.0, constant: 0))
        if cancelButtonTitle != nil {
            // THERE IS A CANCEL BUTTON
            cancelButtonIndexVar = 0
            if otherButtonTitles != nil && otherButtonTitles!.count == 1 {
                // TWO BUTTONS
                self.setupTwoButtons(cancel: true, left: cancelButtonTitle!, right: otherButtonTitles![0], container: buttonContainer)
            } else {
                // ONLY ONE BUTTON
                self.setupOneButton(cancelButtonTitle!, container: buttonContainer)
            }
        } else {
            if otherButtonTitles != nil && otherButtonTitles!.count == 2 {
                self.setupTwoButtons(cancel: false, left: otherButtonTitles![0], right: otherButtonTitles![1], container: buttonContainer)
            } else {
                self.setupOneButton(otherButtonTitles![0], container: buttonContainer)
            }
        }
    }
    
    func setupTwoButtons(#cancel: Bool!, left: String!, right: String!, container: UIView!){
        // INSERT SEPARATION BAR
        let separatorView = UIView(frame: CGRectZero)
        separatorView.setTranslatesAutoresizingMaskIntoConstraints(false)
        separatorView.backgroundColor = separatorColor
        container.addSubview(separatorView)
        separatorView.addConstraint(NSLayoutConstraint(item: separatorView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.5))
        container!.addConstraint(NSLayoutConstraint(item: separatorView, attribute: .Top, relatedBy: .Equal, toItem: container!, attribute: .Top, multiplier: 1.0, constant: 0))
        container!.addConstraint(NSLayoutConstraint(item: separatorView, attribute: .Bottom, relatedBy: .Equal, toItem: container!, attribute: .Bottom, multiplier: 1.0, constant: 0))
        container!.addConstraint(NSLayoutConstraint(item: separatorView, attribute: .CenterX, relatedBy: .Equal, toItem: container!, attribute: .CenterX, multiplier: 1.0, constant: 0))
        // LEFT BUTTON
        let button1 = UIButton()
        button1.setTranslatesAutoresizingMaskIntoConstraints(false)
        let attributedString = NSMutableAttributedString(string: left.uppercaseString)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: buttonTextColor, range: NSRange(location: 0, length: count(left)))
        if cancel == true {
            attributedString.addAttribute(NSFontAttributeName, value: cancelButtonFont, range: NSRange(location: 0, length: count(left)))
        } else {
            attributedString.addAttribute(NSFontAttributeName, value: otherButtonFont, range: NSRange(location: 0, length: count(left)))
        }
        var highlightedString = NSMutableAttributedString(attributedString: attributedString)
        highlightedString.addAttribute(NSForegroundColorAttributeName, value: buttonTextColor.colorWithAlphaComponent(0.5), range: NSRange(location: 0, length: count(left)))
        button1.setAttributedTitle(attributedString, forState: .Normal)
        button1.setAttributedTitle(highlightedString, forState: .Highlighted)
        button1.tag = 0
        container.addSubview(button1)
        container!.addConstraint(NSLayoutConstraint(item: button1, attribute: .Top, relatedBy: .Equal, toItem: container!, attribute: .Top, multiplier: 1.0, constant: 0))
        container!.addConstraint(NSLayoutConstraint(item: button1, attribute: .Bottom, relatedBy: .Equal, toItem: container!, attribute: .Bottom, multiplier: 1.0, constant: 0))
        container!.addConstraint(NSLayoutConstraint(item: button1, attribute: .Left, relatedBy: .Equal, toItem: container!, attribute: .Left, multiplier: 1.0, constant: 0))
        container!.addConstraint(NSLayoutConstraint(item: button1, attribute: .Right, relatedBy: .Equal, toItem: separatorView, attribute: .Left, multiplier: 1.0, constant: 0))
        // RIGHT BUTTON
        let button2 = UIButton()
        button2.setTranslatesAutoresizingMaskIntoConstraints(false)
        let attributedString2 = NSMutableAttributedString(string: right.uppercaseString)
        attributedString2.addAttribute(NSForegroundColorAttributeName, value: buttonTextColor, range: NSRange(location: 0, length: count(right)))
        attributedString2.addAttribute(NSFontAttributeName, value: otherButtonFont, range: NSRange(location: 0, length: count(right)))
        var highlightedString2 = NSMutableAttributedString(attributedString: attributedString2)
        highlightedString2.addAttribute(NSForegroundColorAttributeName, value: buttonTextColor.colorWithAlphaComponent(0.5), range: NSRange(location: 0, length: count(right)))
        button2.setAttributedTitle(attributedString2, forState: .Normal)
        button2.setAttributedTitle(highlightedString2, forState: .Highlighted)
        button2.tag = 1
        container.addSubview(button2)
        container!.addConstraint(NSLayoutConstraint(item: button2, attribute: .Top, relatedBy: .Equal, toItem: container!, attribute: .Top, multiplier: 1.0, constant: 0))
        container!.addConstraint(NSLayoutConstraint(item: button2, attribute: .Bottom, relatedBy: .Equal, toItem: container!, attribute: .Bottom, multiplier: 1.0, constant: 0))
        container!.addConstraint(NSLayoutConstraint(item: button2, attribute: .Right, relatedBy: .Equal, toItem: container!, attribute: .Right, multiplier: 1.0, constant: 0))
        container!.addConstraint(NSLayoutConstraint(item: button2, attribute: .Left, relatedBy: .Equal, toItem: separatorView, attribute: .Right, multiplier: 1.0, constant: 0))
        button1.addTarget(self, action: "dismiss:", forControlEvents: .TouchUpInside)
        button2.addTarget(self, action: "dismiss:", forControlEvents: .TouchUpInside)
    }
    
    func setupOneButton(middle: String!, container: UIView!){
        // MIDDLE BUTTON
        let button1 = UIButton()
        button1.setTranslatesAutoresizingMaskIntoConstraints(false)
        let attributedString = NSMutableAttributedString(string: middle.uppercaseString)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: buttonTextColor, range: NSRange(location: 0, length: count(middle)))
        attributedString.addAttribute(NSFontAttributeName, value: otherButtonFont, range: NSRange(location: 0, length: count(middle)))
        var highlightedString = NSMutableAttributedString(attributedString: attributedString)
        highlightedString.addAttribute(NSForegroundColorAttributeName, value: buttonTextColor.colorWithAlphaComponent(0.5), range: NSRange(location: 0, length: count(middle)))
        button1.setAttributedTitle(attributedString, forState: .Normal)
        button1.setAttributedTitle(highlightedString, forState: .Highlighted)
        button1.tag = 0
        container.addSubview(button1)
        container!.addConstraint(NSLayoutConstraint(item: button1, attribute: .Top, relatedBy: .Equal, toItem: container!, attribute: .Top, multiplier: 1.0, constant: 0))
        container!.addConstraint(NSLayoutConstraint(item: button1, attribute: .Bottom, relatedBy: .Equal, toItem: container!, attribute: .Bottom, multiplier: 1.0, constant: 0))
        container!.addConstraint(NSLayoutConstraint(item: button1, attribute: .Left, relatedBy: .Equal, toItem: container!, attribute: .Left, multiplier: 1.0, constant: 0))
        container!.addConstraint(NSLayoutConstraint(item: button1, attribute: .Right, relatedBy: .Equal, toItem: container!, attribute: .Right, multiplier: 1.0, constant: 0))
        button1.addTarget(self, action: "dismiss:", forControlEvents: .TouchUpInside)
    }
    
    func dismiss(sender:UIButton){
        // BUTTONS CALLBACK
        let index = sender.tag
        self.completition?(alertView: self, buttonIndex: index)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.blackView!.alpha = 0.0
            self.mainView!.alpha = 0.0
        }) { (finished) -> Void in
            self.newWindow!.hidden = true
            objc_setAssociatedObject(self, &self.xoAssociationKey, nil, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        }
    }
}
