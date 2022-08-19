//
//  CommicsView.swift
//  MarvelAPI
//
//  Created by 高橋蓮 on 2022/08/19.
//

import SwiftUI
import SDWebImageSwiftUI

struct ComicsView: View {
    @EnvironmentObject var homeData: HomeViewModel
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                if homeData.fetchedComics.isEmpty {
                    ProgressView()
                        .padding(.top, 30)
                } else {
                    VStack(spacing: 15) {
                        ForEach(homeData.fetchedComics) { comic in
                            ComicRowView(comic: comic)
                        }
                        if homeData.offset == homeData.fetchedComics.count {
                           ProgressView()
                                .padding(.vertical)
                                .onAppear {
                                    print("fetch new data")
                                    homeData.fetchComics()
                                }
                        } else {
                            GeometryReader { reader -> Color in
                                let minY = reader.frame(in: .global).maxY
                                let height = UIScreen.main.bounds.height / 1.3
                                if minY < height && !homeData.fetchedComics.isEmpty {
                                    print("last")
                                    DispatchQueue.main.async {
                                        homeData.offset = homeData.fetchedComics.count
                                    }
                                }
                                return Color.clear
                            }
                            .frame(width: 20, height: 20)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("MARVEL's comics")
        }
        .onAppear {
            if homeData.fetchedComics.isEmpty {
                homeData.fetchComics()
            }
        }
    }
}

struct ComicRowView: View {
    var comic: Comic
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            //HTTP通信は安全でないのでデフォルトではブロックする　→ Infoの「Allow Arbitrary Loads (YES)」にする！！
            WebImage(url: extractImage(data: comic.thumbnail))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(comic.title)
                    .font(.title3)
                    .fontWeight(.bold)
                
                if let description = comic.description {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(4)
                        .multilineTextAlignment(.leading)
                }
                
                HStack(spacing: 10) {
                    ForEach(comic.urls, id: \.self) { data in
                        NavigationLink {
                            WebView(url: extractURL(data: data))
                                .navigationTitle(extractURLType(data: data))
                        } label: {
                            Text(extractURLType(data: data))
                        }
                    }
                }
                
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal)
    }
    
    func extractImage(data: [String:String])->URL {
        let path = data["path"] ?? ""
        let ext = data["extension"] ?? ""
        return URL(string: "\(path).\(ext)")!
    }
    
    func extractURL(data: [String : String]) -> URL {
        let url = data["url"] ?? ""
        return URL(string: url)!
    }
    
    func extractURLType(data: [String: String]) -> String {
        let type = data["type"] ?? ""
        return type.capitalized
    }
}

struct CommicsView_Previews: PreviewProvider {
    static var previews: some View {
        ComicsView()
    }
}
