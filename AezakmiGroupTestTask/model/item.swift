//
//  item.swift
//  AezakmiGroupTestTask
//
//  Created by Никита Иванов on 09.04.2024.
//

import Foundation
import FirebaseFirestore


struct Item : Identifiable, Equatable{
        let id: String
        let name: String
        let number: Int
        let cursor: DocumentSnapshot?
        
        init(id: String, name: String, number: Int, cursor: DocumentSnapshot?) {
            self.id = id
            self.name = name
            self.number = number
            self.cursor = cursor
        }
}
