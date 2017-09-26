//
//  SecondVC.swift
//  Shekhar
//
//  Created by Ved Kshirsagar on 25/09/17.
//  Copyright © 2017 Ved Kshirsagar. All rights reserved.
//

import UIKit
//import <#module#>

class SecondVC: UIViewController {

    @IBOutlet weak var tableLocationData: UITableView!
    var modelObject = NSArray()
    var cache = NSCache<AnyObject, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            modelObject = try context.fetch(LocatioData.fetchRequest()) as NSArray
            if modelObject.count == 0 {
                APIManager.sharedInstance.getLocationData(success: { (result) in
                    for item in result{
                        let ss = item as! LocationModel
                        let task = LocatioData(context: context)
                        task.title = ss.title
                        task.url = ss.thumbnailUrl
                        (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    }
                    self.tableLocationData.reloadData()
                }) { (error) in
                    print("")
                }
            }
        }catch {
            print("Fetching Failed")
        }
    }
    
}

//MARK: Tableview delegate and datasource
extension SecondVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelObject.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        let data1 = modelObject[indexPath.row] as! LocatioData
        let imgLocation = cell.viewWithTag(1) as! UIImageView
        imgLocation.layer.cornerRadius = imgLocation.frame.size.height / 2.0
        imgLocation.clipsToBounds = true
        imgLocation.backgroundColor = UIColor.yellow
        if (self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil){
            cell.imageView?.image = self.cache.object(forKey: data1.url! as AnyObject) as? UIImage
        }else{
            let url:URL! = URL(string: data1.url!)
            let task: URLSessionDownloadTask! = URLSession.shared.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                if let data = try? Data(contentsOf: url){
                    
                    DispatchQueue.main.async {
                        if tableView.cellForRow(at: indexPath) != nil {
                            let img:UIImage! = UIImage(data: data)
                            imgLocation.image = img
                            self.cache.setObject(img, forKey: data1.url! as AnyObject)
                        }
                    }
//                    DispatchQueue.main.async(execute: { () -> Void in
//                        if tableView.cellForRow(at: indexPath) != nil {
//                            let img:UIImage! = UIImage(data: data)
//                            imgLocation.image = img
//                            self.cache.setObject(img, forKey: data1.url! as AnyObject)
//                        }
//                    })
                }
            })
            task.resume()
        }
        let lblTitle = cell.viewWithTag(2) as! UILabel
        lblTitle.text = "\(data1.title ?? "Title not found")"
        lblTitle.adjustsFontSizeToFitWidth = true
        return cell
    }
}
