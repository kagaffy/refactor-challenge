//
//  Service.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshiki Tsukada on 2020/10/05.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Foundation

protocol APIServiceProtocol {
    func request<Output: Decodable>(urlString: String, onSuccess completionHandler: ((Output) -> Void)?, onError errorHandler: ((Error) -> Void)?)
}

final class APIClient: APIServiceProtocol {
    private var task: URLSessionTask?

    func request<Output: Decodable>(urlString: String, onSuccess completionHandler: ((Output) -> Void)?, onError errorHandler: ((Error) -> Void)?) {
        guard let url = URL(string: urlString) else {
            assertionFailure()
            return
        }

        task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                errorHandler?(error)
                return
            }

            guard let data = data else { return }
            do {
                let output = try JSONDecoder().decode(Output.self, from: data)
                DispatchQueue.main.async {
                    completionHandler?(output)
                }
            } catch {
                errorHandler?(error)
            }
        }
        task?.resume()
    }

    func cancel() {
        task?.cancel()
    }
}

final class GitHubAPIService {
    private var service: APIClient?

    func request(by term: String, onSuccess completionHandler: ((SearchResult) -> Void)? = nil, onError errorHandler: ((Error) -> Void)? = nil) {
        let urlString = "https://api.github.com/search/repositories?q=\(term)"
        service = APIClient()
        service?.request(urlString: urlString, onSuccess: completionHandler, onError: errorHandler)
    }

    func cancel() {
        service?.cancel()
    }
}
