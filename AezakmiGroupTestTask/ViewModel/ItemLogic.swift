//
//  ItemLogic.swift
//  AezakmiGroupTestTask
//
//  Created by Никита Иванов on 10.04.2024.
//

import Foundation
import FirebaseFirestore
import Combine

class ItemViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var removalCompleted: Bool = false

    func addItems() {
        let newItems: [Item] = [
            Item(id: UUID(), name: "Кепка вонючка", number: 228),
            Item(id: UUID(), name: "Элемент 2", number: 69)
        ]

        items.append(contentsOf: newItems)

        let db = Firestore.firestore()
        let itemsCollection = db.collection("items")

        let batch = db.batch()

        for item in newItems {
            let newItemRef = itemsCollection.document(item.id.uuidString)

            let itemData: [String: Any] = [
                "id": item.id.uuidString,
                "name": item.name,
                "number": item.number
            ]

            batch.setData(itemData, forDocument: newItemRef)
        }

        batch.commit { error in
            if let error = error {
                print("error adding data on Firestore: \(error.localizedDescription)")
            } else {
                print("data has been added to Firestore successfully")
            }
        }
    }

    func removeItems() {
        let db = Firestore.firestore()
        let itemsCollection = db.collection("items")

        itemsCollection.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("error getting data from Firestore: \(error.localizedDescription)")
                return
            }

            let batch = db.batch()

            querySnapshot?.documents.forEach { document in
                if let itemId = document.data()["id"] as? String {
                    let itemRef = itemsCollection.document(itemId)
                    batch.deleteDocument(itemRef)
                }
            }

            batch.commit { error in
                if let error = error {
                    print("error deliting data Firestore: \(error.localizedDescription)")
                } else {
                    print("data has been deleted from Firestore successfully")
                    DispatchQueue.main.async {
                        self.removalCompleted = true
                    }
                }
            }
        }
    }
}
