//
//  NaverSearchResponse.swift
//  Peekabook
//
//  Created by 고두영 on 2023/01/10.
//

import Foundation

class DataManager {
    static let shared: DataManager = DataManager()
    var searchResult: PostBook?
    
    private init() {
        
    }
}

// MARK: - PostBook
struct PostBook: Codable {
    let lastBuildDate: String
    let total, start: Int
    var display: Int
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let title: String
    let link: String
    let image: String
    let author, discount, publisher, pubdate: String
    let isbn, description: String
}
