//
//  ViewController.swift
//  DemoPoppup
//
//  Created by gray buster on 6/8/18.
//  Copyright © 2018 gray buster. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var menuLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var blurMenuView: UIVisualEffectView!
    @IBOutlet weak var mainViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var bgImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        presentationController?.delegate = self
        blurMenuView.layer.cornerRadius = 15
        menuView.layer.shadowColor = UIColor.black.cgColor
        menuView.layer.shadowOpacity = 1
        menuView.layer.shadowOffset = CGSize(width: 5, height: 0)
        view.addSubview(menuView)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panPerformed(_:)))
        view.addGestureRecognizer(panGesture)
        menuLeadingConstraint.constant = -175
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    @IBAction func panPerformed(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            let translation = sender.translation(in: self.view).x
            
            if translation > 0 {
                if menuLeadingConstraint.constant < 20 {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.menuLeadingConstraint.constant += translation / 10
                        self.view.layoutIfNeeded()
                    })
                }
            }else {
                if menuLeadingConstraint.constant > -175 {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.menuLeadingConstraint.constant += translation / 10
                        self.view.layoutIfNeeded()
                    })
                }
            }
            
            
        }else if sender.state == .ended {
            if menuLeadingConstraint.constant < -100 {
                if menuLeadingConstraint.constant < 20 {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.menuLeadingConstraint.constant = -175
                        self.view.layoutIfNeeded()
                    })
                }else {
                    if menuLeadingConstraint.constant < 20 {
                        UIView.animate(withDuration: 0.2, animations: {
                            self.menuLeadingConstraint.constant = 0
                            self.view.layoutIfNeeded()
                        })
                    }
                }
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mainViewConstraint.constant = -195
        for i in [bgImage,mainView,welcomeLabel,buttonStackView] {
            i?.alpha = 0
        }
        UIView.animate(withDuration: 1, animations: {
            self.bgImage.alpha = 1
        }) { (true) in
            self.animateView()
        }
    }
    
    func animateView() {
        UIView.animate(withDuration: 1, animations: {
            self.mainView.alpha = 1
            self.mainViewConstraint.constant = 0
            self.view.layoutIfNeeded()
        }) { (true) in
            self.animateLabel()
        }
    }
    
    func animateLabel() {
        UIView.animate(withDuration: 1, animations: {
            self.welcomeLabel.alpha = 1
        }) { (true) in
            self.animateStackButton()
        }
    }
    
    func animateStackButton() {
        UIView.animate(withDuration: 1, animations: {
            self.buttonStackView.alpha = 1
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Popover" {
            if let popoverVC = segue.destination as? PopupViewController , let popupVC = popoverVC.presentationController as? UIPopoverPresentationController {
                popupVC.delegate = self
                popupVC.permittedArrowDirections = .up
                popupVC.sourceView = (sender as! UIView)
                popupVC.sourceRect = (sender as! UIButton).bounds
            }
        }
    }

    @IBAction func getAPI(_ sender: Any) {
        
    }
    
    
    @IBAction func postAPI(_ sender: Any) {
        guard let url = URL(string: Url.updateNotification) else { print("Failed Url"); return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let postString = "Id=7944&IdNotification=89".data(using: .utf8)
        request.httpBody = postString
        let task = URLSession.shared.dataTask(with: request) { data,response,error in
            guard let data = data , error == nil else { return }
            do {
                let sentPost = try JSONSerialization.jsonObject(with: data, options:[])
                print(sentPost)
            }catch{
                print(error)
            }
        }
        task.resume()
    }
}
struct Url {
    static let updateNotification = "http://117.6.131.222:4002/DidiNotification/UpdateAsync"
}
