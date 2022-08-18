//
//  CharactersView.swift
//  MarvelAPI
//
//  Created by 高橋蓮 on 2022/08/17.
//

import SwiftUI
import SDWebImageSwiftUI

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
                            .textInputAutocapitalization(.none)
                            .disableAutocorrection(true)
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
                            CharacterRowView(character: data)
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


struct CharacterRowView: View {
    var character: Character
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            //HTTP通信は安全でないのでデフォルトではブロックする　→ Infoの「Allow Arbitrary Loads (YES)」にする！！
            WebImage(url: extractImage(data: character.thumbnail))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(character.name)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text(character.description)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
            }
            Spacer(minLength: 0)
        }
    }
    
    func extractImage(data: [String:String])->URL {
        let path = data["path"] ?? ""
        let ext = data["extension"] ?? ""
        return URL(string: "\(path).\(ext)")!
    }
}
