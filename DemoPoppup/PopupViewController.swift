//
//  PopupViewController.swift
//  DemoPoppup
//
//  Created by gray buster on 6/8/18.
//  Copyright © 2018 gray buster. All rights reserved.
//

import UIKit


class PopupViewController: UIViewController,UITextFieldDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ageTextField.becomeFirstResponder()
        getImageFromURL()
    }
    
    lazy var spinner:UIActivityIndicatorView = {
       var spinner = UIActivityIndicatorView()
        spinner.activityIndicatorViewStyle = .whiteLarge
        spinner.color = UIColor.black
        spinner.center = imageView.center
        spinner.hidesWhenStopped = true
        imageView?.addSubview(spinner)
        return spinner
    }()
    
    
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == ageTextField){
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        spinner.startAnimating()
    }
    
    @objc func addPulse() {
        let pulse = Pulsing(numberOfPulses: 1, radius: 110, position: imageView.center)
        pulse.animationDuration = 0.8
        pulse.backgroundColor = UIColor.blue.cgColor
        self.imageView.layer.addSublayer(pulse)
    }
    
    func getImageFromURL() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addPulse))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(tapGesture)
        
        if let url = URL(string: "https://static.zerochan.net/Kuroha.Neko.full.1702432.jpg") {
            DispatchQueue.global().async { [weak self] in
                do {
                    let data = try Data(contentsOf: url)
                    
                    DispatchQueue.main.async {
                        self?.imageView.image = UIImage(data: data)
                        self?.spinner.stopAnimating()
                    }
                }catch {
                    print(error)
                }
            }
        }
    }
    
    
    @IBAction func showingAge(_ sender: UIButton) {
        if ageTextField.text != "" {
            let alert = UIAlertController(title: "Thông báo!", message: "Tuổi của bạn là " + ageTextField.text!, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { alert in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }else {
            ageTextField.shake()
            
        }
        
    }
}
extension UITextField {
    func shake () {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 4, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 4, y: self.center.y))
        
        self.layer.add(animation, forKey: "position")
    }
}
   

