//
//  HomeViewModel.swift
//  MarvelAPI
//
//  Created by 高橋蓮 on 2022/08/17.
//

import SwiftUI
import Combine
import CryptoKit

class HomeViewModel: ObservableObject {
    @Published var searchQuery = ""
    @Published var fetchedCharacters: [Character]? = nil
    @Published var fetchedComics: [Comic] = []
    @Published var offset: Int = 0
    var searchCancellable: AnyCancellable? = nil
    
    //タイピングが終わると、textViewの文字が認識される
    init() {
        searchCancellable = $searchQuery
            .removeDuplicates()
            .debounce(for: 0.6, scheduler: RunLoop.main)
            .sink(receiveValue: { str in
                if str == "" {
                    self.fetchedCharacters = nil
                } else {
                    self.searchCharacter()
                }
            })
    }
    
    func searchCharacter() {
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(data: "\(ts)\(privateKey)\(publicKey)")
        let originalQuery = searchQuery.replacingOccurrences(of: " ", with: "%20")
        let url = "https://gateway.marvel.com:443/v1/public/characters?nameStartsWith=\(originalQuery)&ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: URL(string: url)!) { data, _, err in
            if let error = err {
                print(error.localizedDescription)
            }
            guard let APIData = data else {
                print("no data found")
                return
            }
            do {
                //decoding API
                let characters = try JSONDecoder().decode(APIResult.self, from: APIData)
                DispatchQueue.main.async {
                    if self.fetchedCharacters == nil {
                        self.fetchedCharacters = characters.data.results
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        .resume()
    }
    
    func fetchComics() {
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(data: "\(ts)\(privateKey)\(publicKey)")
        let url = "https://gateway.marvel.com:443/v1/public/comics?limit=20&offset=\(offset)&ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: URL(string: url)!) { data, _, err in
            if let error = err {
                print(error.localizedDescription)
            }
            guard let APIData = data else {
                print("no data found")
                return
            }
            do {
                //decoding API
                let comics = try JSONDecoder().decode(APIComicResult.self, from: APIData)
                DispatchQueue.main.async {
                    self.fetchedComics.append(contentsOf: comics.data.results)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        .resume()
    }
    
    func MD5(data: String) -> String {
        let hash = Insecure.MD5.hash(data: data.data(using: .utf8) ?? Data())
        return hash.map {
            String(format: "%02hhx", $0)
        }
        .joined()
    }
}
