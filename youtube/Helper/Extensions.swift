//
//  Extensions.swift
//  youtube
//
//  Created by Mandeep Sarangal on 2018-10-03.
//  Copyright © 2018 Mandeep Sarangal. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIView{
    func addConstraintsWithFormat(format: String, views: UIView...){
        
        // create an indexing dictionary
        var viewDictionary = [String: UIView]()
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewDictionary))
        
    }
    
}

// cache for images
let imageCache = NSCache<NSString, UIImage>()

extension UIImageView{
    func loadImageUsingUrlString(urlString: String){
        let url = URL(string: urlString)
        
        image = nil
        
//        if let imageFromCache = imageCache.object(forKey: urlString as NSString) as? UIImage{
//            self.image = imageFromCache
//            print("FROM CACHE")
//            return
//        }
        
        let request = URLRequest(url:url! as URL)
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if error != nil{
                print(error!)
                return
            }
            
            // image successfully fetched, now update UI on main thread
            DispatchQueue.main.async{
                // Store the fetched image  in cache
//                let imageToCache = UIImage(data: data!)
//                imageCache.setObject(imageToCache!, forKey: urlString as NSString)
                self.image = UIImage(data: data!)
                
            }
            
        }).resume()
    }
}
