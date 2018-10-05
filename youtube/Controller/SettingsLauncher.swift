//
//  SettingsLauncher.swift
//  youtube
//
//  Created by Mandeep Sarangal on 2018-10-04.
//  Copyright © 2018 Mandeep Sarangal. All rights reserved.
//

import UIKit

class Setting: NSObject{
    var name: SettingName
    var imageName: String
    
    init(name: SettingName, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}

// enums for type safe usage of strings
enum SettingName: String {
    case settings = "Settings"
    case help = "Help"
    case termsPrivacy = "Terms & privacy policy"
    case switchAccount = "Switch Account"
    case sendFeedback = "Send feedback"
    case cancel = "Cancel"
}

class SettingsLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    let blackView = UIView()
    
    // settings collection view
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return cv
    }()
    
    let settings: [Setting] = {
        
        let cancelSetting = Setting(name: .cancel, imageName: "cancel")
        return [Setting(name: .settings, imageName: "settings"),
                Setting(name: .help, imageName: "help"),
                Setting(name: .termsPrivacy, imageName: "terms_and_privacy"),
                Setting(name: .sendFeedback, imageName: "feedback"),
                Setting(name: .switchAccount, imageName: "switch_account"),
                cancelSetting]
        
    }()
    
    let cellId = "cellId"
    let cellHeight: CGFloat = 50
    
    func showSettings(){
        if let window = UIApplication.shared.keyWindow{
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            let height: CGFloat = CGFloat(settings.count) * cellHeight
            let y: CGFloat = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 200)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: y, width: window.frame.width, height: height)
            }, completion: nil)
        }
    }
    
    @objc func handleDismiss(){
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow{
            self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 200)
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingsCell
        let setting = settings[indexPath.item]
        cell.setting = setting
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 
    }
    
    var homeController: HomeController?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow{
                 self.collectionView.frame = CGRect(x: 0, y: window.frame.height , width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
           
        }) { (completed: Bool) in
            let setting = self.settings[indexPath.item]
            if setting.name != .cancel{
              self.homeController?.showControllerForSetting(setting: setting)
            }
        }
    }
    override init(){
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(SettingsCell.self, forCellWithReuseIdentifier: cellId)
    }
}
