//
//  ViewController.swift
//  youtube
//
//  Created by Mandeep Sarangal on 2018-10-01.
//  Copyright © 2018 Mandeep Sarangal. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    //videos array
//    var videos: [Video] = {
//        var taylorSwiftChannel = Channel()
//        taylorSwiftChannel.name = "TaylorSwift"
//        taylorSwiftChannel.profileImageName = "taylor_swift"
//
//        var blankSpaceVideo = Video()
//        blankSpaceVideo.title = "Taylor Swift - Blank Space"
//        blankSpaceVideo.thumbnailImageName = "taylor_swift_blank_space"
//        blankSpaceVideo.channel = taylorSwiftChannel
//        blankSpaceVideo.numberOFViews = 3456456456
//
//
//        var badBloodVideo = Video()
//        badBloodVideo.title = "Taylor Swift - Bad Blood featuring Kendrick Lamar"
//        badBloodVideo.thumbnailImageName = "taylor_swift_bad_blood"
//        badBloodVideo.channel = taylorSwiftChannel
//        badBloodVideo.numberOFViews = 6556456456
//
//        return [blankSpaceVideo, badBloodVideo]
//    }()
    
    var videos: [Video]?
    
    func fetchVideos(){
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
                
                self.videos = [Video]()
                
                for dictionary in json as! [[String : AnyObject]] {
                    let video = Video()
                    video.title = dictionary["title"] as? String
                    video.thumbnailImageName = dictionary["thumbnail_image_name"] as? String
                    
                    let channelDictionary = dictionary["channel"] as? [String : AnyObject]
                    
                    let channel = Channel()
                    channel.name = channelDictionary!["name"] as? String
                    channel.profileImageName = channelDictionary!["profile_image_name"] as? String
                    
                    video.channel = channel
                    self.videos?.append(video)
                }
                
                // reload collectionView, on main UI thread
                DispatchQueue.main.async{
                    self.collectionView?.reloadData()
                }
                
            }catch let jsonError{
                print (jsonError)
            }
            
            
        }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fetch videos
        fetchVideos()
        
        navigationItem.title = "Home"
        navigationController?.navigationBar.isTranslucent = false
        
        // Custom Navigation bar title
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "Home"
        titleLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        navigationItem.titleView = titleLabel
        
        collectionView?.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: "cellId")
        
        collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        setUpMenuBar()
        setUpMenuBarButtons()
    }
    
    func setUpMenuBarButtons(){
        // search
        let searchImage = UIImage(named: "search_icon")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        //more
        let moreImage = UIImage(named: "more_icon")?.withRenderingMode(.alwaysOriginal)
        let moreBarButtonItem = UIBarButtonItem(image: moreImage, style: .plain, target: self, action: #selector(handleMore))
        
        navigationItem.rightBarButtonItems = [moreBarButtonItem, searchBarButtonItem]
        
    }
    
    lazy var settingsLauncher: SettingsLauncher = {
        let launcher = SettingsLauncher()
        launcher.homeController = self
        return launcher
    }()
    
    
    @objc func handleMore(){
        settingsLauncher.showSettings()
    }
    
    func showControllerForSetting(setting: Setting){
         let dummySettingsViewController = UIViewController()
        dummySettingsViewController.navigationItem.title = setting.name.rawValue
        dummySettingsViewController.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        // for nav bar title color
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.pushViewController(dummySettingsViewController, animated: true)
    }
    
    @objc func handleSearch(){
        print(123)
    }
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        mb.backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 31, alpha: 1)
        return mb
    }()
    
    private func setUpMenuBar() {
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:|[v0(50)]", views: menuBar)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return videos?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! VideoCell
        cell.video = videos?[indexPath.item]
        cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return cell
    }
    
    // callback methods of UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (view.frame.width - 16 - 16) * 9/16
        return CGSize(width: view.frame.width, height: height + 16 + 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}





