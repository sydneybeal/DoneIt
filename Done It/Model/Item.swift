//
//  Item.swift
//  Done It
//
//  Created by Sydney Beal on 9/28/18.
//  Copyright © 2018 Sydney Beal. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var isDone : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
