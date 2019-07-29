//
//  ViewController.swift
//  doodletest
//
//  Created by administrator on 29/07/19.
//  Copyright © 2019 administrator. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
struct post {
    let name : String
}
class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var content: UITableView!
    var posts = [post]()
    var m=0
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! tbc
        print(cell)
        cell.labelview.text = posts[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.posts[sourceIndexPath.row]
        posts.remove(at: sourceIndexPath.row)
        posts.insert(movedObject, at: destinationIndexPath.row)
    }
    let headers : [String : String] = [
        "Authorization" : "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9nb2xmYmV0YS5kb29kbGVibHVlZGVtby5pblwvcHVibGljXC9hcGlcL2xvZ2luIiwiaWF0IjoxNTY0Mzg1OTIxLCJuYmYiOjE1NjQzODU5MjEsImp0aSI6ImxsNHBRTmN4QTRlUUE1OTMiLCJzdWIiOjMsInBydiI6Ijg3ZTBhZjFlZjlmZDE1ODEyZmRlYzk3MTUzYTE0ZTBiMDQ3NTQ2YWEifQ.TVr7bWlnKQk9PHpxrJRuygps_s4-YJJaKtX6r9Vx3Sk"
        
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        content.delegate=self
        content.dataSource=self
        self.content.isEditing = true
        // Do any additional setup after loading the view.
        let body : [String :String]=[ "active":"1",
                                      "radius":"100",
                                      "referenceLatitude":"13.02",
                                      "referenceLongitude":"80.23"]
        Alamofire.request("http://golfbeta.doodlebluedemo.in/public/api/courselist", method:.post, parameters: body, encoding: JSONEncoding.default, headers: headers).responseJSON{(response) in
            guard let data = response.data else { return }
            do{
                let json = try JSON(data: data)
                var a = json["data"]["courses"]
                for _ in a
                {
                    var d = a[self.m]["courseName"]
                    self.posts.insert(post(name: d.stringValue), at: 0)
                    self.m=self.m+1
                    print(d.stringValue)
                }
                print(self.posts)
            }
            catch{
                debugPrint(error)
            }
            self.content.reloadData()
        }
        
    }


}
