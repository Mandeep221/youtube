//
//  MenuBar.swift
//  youtube
//
//  Created by Mandeep Sarangal on 2018-10-03.
//  Copyright © 2018 Mandeep Sarangal. All rights reserved.
//

import Foundation
import UIKit

class MenuBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 31, alpha: 1)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    let horizontalBarView: UIView = {
        let bar = UIView()
        bar.backgroundColor = UIColor(white: 0.97, alpha: 1)
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    let cellId = "cellId"
    let imageNames = ["home","trending","subscription","account"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        let selectedIndexPath = NSIndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: [])
        
        setUpHorizontalBar()
    }
    
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    
    func setUpHorizontalBar(){
        addSubview(horizontalBarView)
        
        // old school way, usinf frame
//        horizontalBarView.frame = CGRect(x: 0, y: y!, width: collectionView.frame.width/4, height: height!)
//
        //new shcool way in iOS 9
        //we need x, y, width, height
        
        // this means, the left edge of horizontalBarView will match the left edge of the
        //whole menu view the first time it gets rendered
        horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftAnchorConstraint?.isActive = true


        // this means, the bottom edge of horizontalBarView will match the bottom edge of the
        //whole menu view the first time it gets rendered
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        // this means, width of horizontalBarView will be 1/4 of the
        //whole menu view width the first time it gets rendered
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/4).isActive = true

        // this means, height of horizontalBarView will be a CGFloat constant of
        //value 8 the first time it gets rendered
        horizontalBarView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        cell.imageView.image = UIImage(named: imageNames[indexPath.item])?.withRenderingMode(.alwaysTemplate)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width/4, height: frame.height)
    }
    
    // this call back is to remove all unnecessary inset spaces between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let xValue = CGFloat(indexPath.item) * frame.width/4
        
        // xValue/leftEdge changes everytime index of the selected item changes,
        //hence bar changes position
        horizontalBarLeftAnchorConstraint?.constant = xValue
        
        // animate the bar
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MenuCell: BaseCell{
    
    let imageView: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "home")
        iv.tintColor = UIColor.rgb(red: 91, green: 14, blue: 13, alpha: 1)
        return iv
    }()
    
    override var isHighlighted: Bool{
        didSet{
            imageView.tintColor = isHighlighted ? UIColor.white : UIColor.rgb(red: 91, green: 14, blue: 13, alpha: 1)
        }
    }
    
    override var isSelected: Bool{
        didSet{
            imageView.tintColor = isSelected ? UIColor.white : UIColor.rgb(red: 91, green: 14, blue: 13, alpha: 1)
        }
    }
    
    override func setUpViews() {
        super.setUpViews()
        addSubview(imageView)
        addConstraintsWithFormat(format: "H:[v0(24)]", views: imageView)
        addConstraintsWithFormat(format: "V:[v0(24)]", views: imageView)
        
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        
        backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 31, alpha: 1)
    }
    
}
