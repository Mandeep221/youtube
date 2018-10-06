//
//  ApiService.swift
//  youtube
//
//  Created by Mandeep Sarangal on 2018-10-06.
//  Copyright © 2018 Mandeep Sarangal. All rights reserved.
//

import Foundation

class ApiService: NSObject{
    
    static let sharedInstance = ApiService()
    
    func fetchVideos(completion: @escaping ([Video]) -> ()) {
        let url = NSURL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json")
        let request = URLRequest(url:url! as URL)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil{
                print(error!)
                return
            }
            
            // in case of success
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                
                var videos = [Video]()
                
                for dictionary in json as! [[String : AnyObject]] {
                    let video = Video()
                    video.title = dictionary["title"] as? String
                    video.thumbnailImageName = dictionary["thumbnail_image_name"] as? String
                    
                    let channelDictionary = dictionary["channel"] as? [String : AnyObject]
                    
                    let channel = Channel()
                    channel.name = channelDictionary!["name"] as? String
                    channel.profileImageName = channelDictionary!["profile_image_name"] as? String
                    
                    video.channel = channel
                    videos.append(video)
                }
                
                // reload collectionView, on main UI thread
                DispatchQueue.main.async{
                    completion(videos)
                }
                
            }catch let jsonError{
                print (jsonError)
            }
            
            
            }.resume()
    }
}
