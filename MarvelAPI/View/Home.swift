//
//  Home.swift
//  MarvelAPI
//
//  Created by 高橋蓮 on 2022/08/17.
//

import SwiftUI

struct Home: View {
    //property
    @StateObject var homeData = HomeViewModel()
    
    //body
    var body: some View {
        TabView {
            //Characters View
            CharactersView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Characters")
                }
                .environmentObject(homeData)
            Text("Comics")
                .tabItem {
                    Image(systemName: "books.vertical.fill")
                    Text("Comics")
                }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
