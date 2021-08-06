//
//  FilterModel.swift
//  DisplayFilterUI_v2
//
//  Created by Akanksha Gupta on 27/07/21.
//

import Foundation

struct FilterModel: Codable {
    let data: DataClass?
}

struct DataClass: Codable {
    let categories: [Category]?
    let exclude_list: [[ExcludeList]]?
}

struct Category: Codable {
    let category_id: String?
    let filters: [Filter]?
    let name: String?
}

struct Filter: Codable {
    let filterDefault: Int?
    let id, name: String?

    enum CodingKeys: String, CodingKey {
        case filterDefault = "default"
        case id, name
    }
}

struct ExcludeList: Codable, Hashable {
    let category_id: String?
    let filter_id: String?
}

extension ExcludeList: Equatable {
    static func == (lhs: ExcludeList, rhs: ExcludeList) -> Bool {
            return
                lhs.category_id == rhs.category_id &&
                lhs.filter_id == rhs.filter_id
        }
}
