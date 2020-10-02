//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

final class ViewController2: UIViewController {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var languageLabel: UILabel!
    @IBOutlet private var starsLabel: UILabel!
    @IBOutlet private var watchersLabel: UILabel!
    @IBOutlet private var forksLabel: UILabel!
    @IBOutlet private var issuesLabel: UILabel!

    var vc: ViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let idx = vc?.index, let repo = vc?.repository[idx] else { return }

        languageLabel.text = "Written in \(repo["language"] as? String ?? "")"
        starsLabel.text = "\(repo["stargazers_count"] as? Int ?? 0) stars"
        watchersLabel.text = "\(repo["watchers_count"] as? Int ?? 0) watchers"
        forksLabel.text = "\(repo["forks_count"] as? Int ?? 0) forks"
        issuesLabel.text = "\(repo["open_issues_count"] as? Int ?? 0) open issues"
        getImage()
    }

    private func getImage() {
        guard let index = vc?.index, let repo = vc?.repository[index] else { return }

        titleLabel.text = repo["full_name"] as? String

        guard let owner = repo["owner"] as? [String: Any],
            let imageUrl = owner["avatar_url"] as? String,
            let url = URL(string: imageUrl) else { return }

        URLSession.shared.dataTask(with: url) { data, _, err in
            if let err = err {
                print(err)
                return
            }
            guard let data = data else { return }
            if let img = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = img
                }
            }
        }.resume()
    }
}
