//
//  Category.swift
//  Todey
//
//  Created by Foster Brown on 4/2/18.
//  Copyright © 2018 Foster Brown. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var name: String = ""
    var items = List<Item>()
}
