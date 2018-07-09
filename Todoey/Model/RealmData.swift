//
//  RealmData.swift
//  Todoey
//
//  Created by Vincent Tsang on 7/6/18.
//  Copyright © 2018 Vincent Tsang. All rights reserved.
//

import Foundation
import RealmSwift

class RealmData : Object {
    // use dynamic dispatch - dynamically updates if user changes info while app running
    @objc dynamic var name : String = ""
    @objc dynamic var age : Int = 0
}
