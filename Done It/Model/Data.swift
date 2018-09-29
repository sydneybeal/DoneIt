//
//  Data.swift
//  Done It
//
//  Created by Sydney Beal on 9/28/18.
//  Copyright © 2018 Sydney Beal. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var age : Int = 0
}
