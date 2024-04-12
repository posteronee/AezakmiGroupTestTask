//
//  ContentView.swift
//  AezakmiGroupTestTask
//
//  Created by Никита Иванов on 09.04.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var itemViewModel = ItemViewModel()
    @State private var searchText = ""
    
    var body: some View {
      VStack {
        HStack {
          Image(systemName: "magnifyingglass")
            .foregroundColor(.gray)
          TextField("Search by the name", text: $searchText)
            .padding(.leading, 8)
          if !searchText.isEmpty {
            Button(action: {
              searchText = ""
            }) {
              Image(systemName: "xmark.circle.fill")
                .foregroundColor(.gray)
                .padding(.trailing, 8)
            }
          }
        }
        .padding()
        .background(Color(.systemGray5))
        .cornerRadius(10)

        HStack {
          Button(action: {
            searchText = ""
          }) {
            Image(systemName: "globe")
              .foregroundColor(.black)
          }
          Spacer()
          Menu {
            Button(action: {
              if itemViewModel.items.isEmpty { return }
              itemViewModel.sortingOption = .nameAZ
              itemViewModel.sortItems()
            }) {
              Label("Name: A...Z", systemImage: "arrow.up.arrow.down.circle")
            }

            Button(action: {
              if itemViewModel.items.isEmpty { return }
              itemViewModel.sortingOption = .nameZA
              itemViewModel.sortItems()
            }) {
              Label("Name: Z...A", systemImage: "arrow.up.arrow.down.circle.fill")
            }

            Button(action: {
              if itemViewModel.items.isEmpty { return }
              itemViewModel.sortingOption = .number1to100
              itemViewModel.sortItems()
            }) {
              Label("Number: 1...100", systemImage: "arrow.up.arrow.down.square")
            }

            Button(action: {
              if itemViewModel.items.isEmpty { return }
              itemViewModel.sortingOption = .number100to1
              itemViewModel.sortItems()
            }) {
              Label("Number: 100...1", systemImage: "arrow.up.arrow.down.square.fill")
            }
          } label: {
            Label("Sort by:", systemImage: "arrow.up.and.down.text.horizontal")
              .foregroundColor(.black)
          }
          .padding()
        }

        ScrollView {
          LazyVStack {
            ForEach(itemViewModel.filteredItems(searchText: searchText)) { item in
              ItemView(item: item)
                .onAppear {
                    if item == itemViewModel.items.last && !itemViewModel.isLoadingMore {
                                      itemViewModel.loadMoreItemsIfNeeded(currentItem: item)
                    }
                }
            }
            .padding()
          }
        }

        if itemViewModel.isLoadingMore {
          ProgressView()
            .padding()
        }
      }
      .padding()
      .onAppear {
        itemViewModel.getItems()
      }
    }
  }

struct ItemView: View {
  let item: Item

  var body: some View {
    HStack {
      Text(item.name)
        .foregroundColor(.blue)
        .font(.headline)

      Spacer()

      Text("\(item.number)")
        .foregroundColor(.green)
        .font(.headline)
    }
    .padding(10)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
