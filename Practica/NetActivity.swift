//
//  NetActivity.swift
//  Practica
//
//  Created by Alejandro Perez parra on 25/11/17.
//  Copyright © 2017 Alejandro Pérez Parra. All rights reserved.
//

import UIKit

class NetActivity {
    
    static var shared = NetActivity()
    
    fileprivate init() {
    }
    
    fileprivate var netActivityCredit = 0
    func incr(){
        DispatchQueue.main.async {
            self.netActivityCredit += 1
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    func decr () {
        DispatchQueue.main.async {
            self.netActivityCredit-=1
            if self.netActivityCredit<1 {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }

}
