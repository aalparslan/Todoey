//
//  Category.swift
//  Todoey
//
//  Created by Guest on 1/21/19.
//  Copyright © 2019 Guest. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    
    @objc dynamic var name : String =  ""
    let items = List<Item>()
}
