//
//  VisitsTableViewController.swift
//  Practica
//
//  Created by Alejandro Perez parra on 21/11/17.
//  Copyright © 2017 Alejandro Pérez Parra. All rights reserved.
//

import UIKit

typealias Visit = [String : Any]


class VisitsTableViewController: UITableViewController {
    var strurl = ""
    var visits = [Visit]()
    var imgCache = [String:UIImage]()
    var session = URLSession.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadVisits()
        tableView.reloadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func downloadVisits() {
        
        if let url = URL(string: strurl){
            NetActivity.shared.incr()
            
            let t = session.dataTask (with:url) { (data, response, error) in
                
                NetActivity.shared.decr()
                
                if error != nil {
                    print("error tipo 1" , error!.localizedDescription)
                    return
                }
                
                if (response as! HTTPURLResponse).statusCode != 200 {
                    print ("Error 2")
                    return
                    
                }
                if let visits = (try? JSONSerialization.jsonObject(with: data!)) as? [Visit]{
                    DispatchQueue.main.async {
                        self.visits = visits
                        self.tableView.reloadData()
                    }
                    
                    
                }
            }
            t.resume()
            
            
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return visits.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Visit Cell", for: indexPath) as! VisitasTableViewCell
        let visit = visits[indexPath.row]
        
        cell.Nombre.text = ""
        cell.Fecha.text=""
        cell.ImagenVisitas.image = #imageLiteral(resourceName: "Image-1")
        cell.Objetivos.text = ""
        
        // cell.imageView?.image = UIImage (named: "noface")
        if let customer = visit["Customer"] as? [String:Any],
            let name = customer ["name"] as? String {
            cell.Nombre.text = name
        }
        if let notas = visit["notes"] as? String{
            cell.Objetivos.text = notas
        }
        // Convertir un String ISO8601 en una Date:
        if let plannedFor = visit["plannedFor"] as? String {
            let df = ISO8601DateFormatter()
            df.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
            if let d = df.date(from: plannedFor){
                let str3 = ISO8601DateFormatter.string(from: d, timeZone: .current, formatOptions: [.withFullDate])
                cell.Fecha.text = str3
            }
        }
        //codigo para salessman visits salessman etc etc
        if let salesman = visit["Salesman"] as? [String:Any],
            let photo = salesman["Photo"] as? [String:Any],
            let strurl = photo["url"] as? String {
            if let img = imgCache[strurl]{
                cell.ImagenVisitas.image = img
            } else {
                updatePhoto(strurl,for: indexPath)
            }
        }
        return cell
    }
    
    
    func updatePhoto(_ strurl: String, for indexPath: IndexPath){
        
        NetActivity.shared.incr()
        DispatchQueue.global().async {
            if let url = URL(string: strurl),
                let data = try? Data(contentsOf: url),
                let img = UIImage(data: data){
                DispatchQueue.main.async {
                    
                    self.imgCache[strurl] = img
                    self.tableView.reloadRows(at: [indexPath],with: .left)
                    
                }
                
                
            }
            
        }
        NetActivity.shared.decr()
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTarget" {
            if let ttvc = segue.destination as? TargetTableViewController{
                if let ip = tableView.indexPathForSelectedRow{
                    ttvc.visit = visits[ip.row]
                }
            }
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
