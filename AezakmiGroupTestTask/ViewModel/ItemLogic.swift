// ItemLogic.swift
// AezakmiGroupTestTask
//
// Created by Никита Иванов on 10.04.2024.
//

import Foundation
import FirebaseFirestore
import Combine

class ItemViewModel: ObservableObject {
  @Published var items: [Item] = []
  @Published var isLoadingMore = false
  @Published var hasMoreData = true
  private var lastDocument: DocumentSnapshot?
  private let db = Firestore.firestore()
  var sortingOption: SortingOption = .nameAZ
  private let limit = 10

  func getItems() {
    isLoadingMore = true

    var query = db.collection("items").order(by: "number", descending: false)
    query = query.limit(to: limit)

    if let lastDocument = lastDocument {
      query = query.start(afterDocument: lastDocument)
    }

    query.getDocuments { [weak self] (querySnapshot, error) in
      guard let self = self else { return }

      if let error = error {
        print("Error fetching documents: \(error.localizedDescription)")
        self.isLoadingMore = false
        return
      }

      guard let documents = querySnapshot?.documents else {
        print("No documents found")
        self.isLoadingMore = false
        return
      }

      let newItems = documents.compactMap { document -> Item? in
        guard let id = document.data()["id"] as? String,
              let name = document.data()["name"] as? String,
              let number = document.data()["number"] as? Int else {
          return nil
        }

        return Item(id: id, name: name, number: number, cursor: document)
      }

      DispatchQueue.main.async {
        if newItems.isEmpty {
          self.hasMoreData = false
        } else {
          self.items.append(contentsOf: newItems)
          self.lastDocument = documents.last
        }
        self.isLoadingMore = false
      }
    }
  }

  func loadMoreItemsIfNeeded(currentItem item: Item) {
    guard !isLoadingMore && hasMoreData && item == items.last else { return }
    getItems()
  }

    func filteredItems(searchText: String) -> [Item] {
        if searchText.isEmpty {
          return items
        } else {
          return items.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
      }

  func sortItems() {
    switch sortingOption {
    case .nameAZ:
      sortByNameAZ()
    case .nameZA:
      sortByNameZA()
    case .number1to100:
      sortByNumber1to100()
    case .number100to1:
      sortByNumber100to1()
    }
  }
}

extension ItemViewModel {
    func sortByNameAZ() {
        items.sort { $0.name.localizedCompare($1.name) == .orderedAscending }
    }

    func sortByNameZA() {
        items.sort { $0.name.localizedCompare($1.name) == .orderedDescending }
    }
    
    func sortByNumber1to100() {
        items.sort { $0.number < $1.number }
  }
    
    func sortByNumber100to1() {
        items.sort { $0.number > $1.number }
  }
}
