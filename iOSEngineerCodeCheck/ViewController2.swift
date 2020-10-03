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

        guard let index = vc?.index, let repo = vc?.searchResult?.repositories[index] else { return }

        languageLabel.text = "Written in \(repo.language ?? "")"
        starsLabel.text = "\(repo.starsCount) stars"
        watchersLabel.text = "\(repo.watchersCount) watchers"
        forksLabel.text = "\(repo.forksCount) forks"
        issuesLabel.text = "\(repo.issuesCount) open issues"
        getImage()
    }

    private func getImage() {
        guard let index = vc?.index, let repo = vc?.searchResult?.repositories[index] else { return }

        titleLabel.text = repo.name

        guard let url = URL(string: repo.avatarUrl) else { return }

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
