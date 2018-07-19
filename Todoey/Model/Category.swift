//
//  Category.swift
//  Todoey
//
//  Created by Vincent Tsang on 7/9/18.
//  Copyright © 2018 Vincent Tsang. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    let items = List<Item>()
    
}
