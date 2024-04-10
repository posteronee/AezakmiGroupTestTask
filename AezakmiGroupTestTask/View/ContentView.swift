//
//  ContentView.swift
//  AezakmiGroupTestTask
//
//  Created by Никита Иванов on 09.04.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var itemViewModel = ItemViewModel()

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    itemViewModel.addItems()
                }, label: {
                    Text("Add Items to Firestore")
                })
                .padding()

                Button(action: {
                    itemViewModel.removeItems()
                }, label: {
                    Text("Remove Items from Firestore")
                })
                .padding()
            }

            List(itemViewModel.items, id: \.id) { item in
                ItemRowView(item: item)
            }
            .padding()
        }
        .padding()
    }
}

struct ItemRowView: View {
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
