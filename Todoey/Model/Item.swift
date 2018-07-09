//
//  Item.swift
//  Todoey
//
//  Created by Vincent Tsang on 7/9/18.
//  Copyright © 2018 Vincent Tsang. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var isDone : Bool = false
//    @objc dynamic var dateCreated: Date?
    
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
