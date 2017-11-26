//
//  PickerViewController.swift
//  Practica
//
//  Created by Alejandro Perez parra on 23/11/17.
//  Copyright © 2017 Alejandro Pérez Parra. All rights reserved.
//

import UIKit


class PickerViewController: UIViewController {
    
    let TOKEN = "5afcb055e398da2a50d4"
    
    @IBOutlet weak var fechaI: UIDatePicker!
    
    @IBOutlet weak var fechaF: UIDatePicker!
    
    var def: UserDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        if let model = def.object(forKey: "mod") as? Date {
           fechaI.date = model
        }
        if let model2 = def.object(forKey: "modelo") as? Date {
            fechaF.date = model2
        }
        
        // Do any additional setup after loading the view.
    }
    
    private func downloadUrl(_ tipo: Int, _ fechaI: UIDatePicker,_ fechaF: UIDatePicker) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let str1 = dateFormatter.string(from: fechaI.date)
        let str2 = dateFormatter.string(from: fechaF.date)
        var strurl = ""
        
        if tipo == 1 {
           strurl = "https://dcrmt.herokuapp.com/api/visits/flattened?token=\(TOKEN)&dateafter=\(str1)&datebefore=\(str2)"
        } else if tipo == 2 {
            strurl = "https://dcrmt.herokuapp.com/api/users/tokenOwner/visits/flattened?token=\(TOKEN)&dateafter=\(str1)&datebefore=\(str2)"
            
        } else if tipo == 3 {
           strurl = "https://dcrmt.herokuapp.com/api/visits/flattened?token=\(TOKEN)&favourites=1&dateafter=\(str1)&datebefore=\(str2)"
            
                    }
        
        return strurl
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if fechaF.date.addingTimeInterval(120) < fechaI.date {
            
            let alert = UIAlertController(title: "Error", message: "Elige una fecha final posterior a la inicial", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(
                title: "Volver",
                style: UIAlertActionStyle.default) {(_: UIAlertAction) -> Void in
                    self.dismiss(animated: true, completion: nil)
            })
            
            present(alert, animated: true, completion: nil)
            return false
            
        }
        return true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        def.set(fechaI.date, forKey: "mod")
        def.set(fechaF.date, forKey: "modelo")
        def.synchronize()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowVisits" {
            if let ttvc = segue.destination as? VisitsTableViewController{
              ttvc.strurl = downloadUrl(1,fechaI,fechaF)
            }
            
        } else if segue.identifier == "ShowMyVisits"{
            if let ttvc = segue.destination as? VisitsTableViewController{
                ttvc.strurl = downloadUrl(2,fechaI,fechaF)
            }
            
        }else if segue.identifier == "ShowFav"{
            if let ttvc = segue.destination as? VisitsTableViewController{
                ttvc.strurl = downloadUrl(3,fechaI,fechaF)
            }
            
        }
        
            
        }
    @IBAction func backInicio(_ segue: UIStoryboardSegue){
        
    }
        
    
}
