//
//  MenuModel.swift
//  carborn
//
//  Created by jud.lee on 2019/11/04.
//  Copyright © 2019 jud.lee. All rights reserved.
//

import Foundation

struct Menu: Codable {
//    var objectId: String
    var name: String
    var id: String?
    var children: [String: Menu]?
}
