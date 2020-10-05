//
//  Repository.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshiki Tsukada on 2020/10/03.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

struct Repository {
    let id: Int
    let name: String
    let language: String?
    let starsCount: Int
    let watchersCount: Int
    let forksCount: Int
    let issuesCount: Int
    let avatarUrl: String
}

// MARK: Decodable

extension Repository: Decodable {
    private struct Owner: Decodable {
        let avatarUrl: String

        private enum CodingKeys: String, CodingKey {
            case avatarUrl = "avatar_url"
        }
    }

    private enum Keys: String, CodingKey {
        case id
        case name = "full_name"
        case language
        case starsCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case issuesCount = "open_issues_count"
        case owner
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        language = try container.decode(String?.self, forKey: .language)
        starsCount = try container.decode(Int.self, forKey: .starsCount)
        watchersCount = try container.decode(Int.self, forKey: .watchersCount)
        forksCount = try container.decode(Int.self, forKey: .forksCount)
        issuesCount = try container.decode(Int.self, forKey: .issuesCount)
        let owner = try container.decode(Owner.self, forKey: .owner)
        avatarUrl = owner.avatarUrl
    }
}

struct SearchResult {
    let repositories: [Repository]
}

// MARK: Decodable

extension SearchResult: Decodable {
    private enum CodingKeys: String, CodingKey {
        case repositories = "items"
    }
}
