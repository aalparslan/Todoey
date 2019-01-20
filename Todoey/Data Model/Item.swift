//
//  Item.swift
//  Todoey
//
//  Created by Guest on 1/20/19.
//  Copyright © 2019 Guest. All rights reserved.
//

import Foundation

class Item : Encodable , Decodable{
    
    var title: String = ""
    var done: Bool = false
}
