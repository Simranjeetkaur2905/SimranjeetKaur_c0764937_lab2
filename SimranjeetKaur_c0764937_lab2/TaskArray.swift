//
//  TaskArray.swift
//  SimranjeetKaur_c0764937_lab2
//
//  Created by Simran Chakkal on 2020-01-21.
//  Copyright © 2020 simran. All rights reserved.
//

import Foundation

class  Taskarray {
    internal init(title: String, days: Int,date:String) {
        self.title = title
        self.days = days
        self.date = date
    }
    
    var title:String
    var days:Int
    var counter = 0
    var date: String
}
