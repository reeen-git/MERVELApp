//
//  CharactersView.swift
//  MarvelAPI
//
//  Created by 高橋蓮 on 2022/08/17.
//

import SwiftUI

struct CharactersView: View {
    @EnvironmentObject var homeData: HomeViewModel
    var body: some View {
        
        NavigationView {
            ScrollView(.vertical, showsIndicators: true, content: {
                VStack(spacing: 15) {
                    //searchbar
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search Characters", text: $homeData.searchQuery)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color.white)
                    .shadow(color: Color.black.opacity(0.06), radius: 5, x: 5, y: 5)
                    .shadow(color: Color.black.opacity(0.06), radius: 5, x: -5, y: -5)
                }
                .padding()
                if let characters = homeData.fetchedCharacters {
                    if characters.isEmpty {
                        Text("no result found")
                            .padding(.top, 20)
                    } else {
                        ForEach(characters) { data in
                            Text(data.name)
                        }
                    }
                } else {
                    if homeData.searchQuery != "" {
                        ProgressView()
                            .padding(.top, 20)
                    }
                }
            })
            .navigationTitle("Marvel")
        }
    }
}

struct CharactersView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
