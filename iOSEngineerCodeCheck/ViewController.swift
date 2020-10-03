//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

final class ViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet private var searchBar: UISearchBar!

    private(set) var searchResult: SearchResult?
    private var task: URLSessionTask?
    private var term: String = ""
    private var urlString: String = ""
    private(set) var index: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.placeholder = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        task?.cancel()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        term = searchBar.text ?? ""
        guard !term.isEmpty else { return }

        urlString = "https://api.github.com/search/repositories?q=\(term)"
        guard let url = URL(string: urlString) else { return }
        task = URLSession.shared.dataTask(with: url) { [weak self] data, _, err in
            if let err = err {
                print(err)
                return
            }
            guard let data = data else { return }
            do {
                self?.searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            } catch {
                print(error)
            }
        }
        // これ呼ばなきゃリストが更新されません
        task?.resume()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            guard let vc = segue.destination as? ViewController2 else {
                assertionFailure()
                return
            }
            vc.vc = self
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResult?.repositories.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let rp = searchResult?.repositories[indexPath.row]
        cell.textLabel?.text = rp?.name
        cell.detailTextLabel?.text = rp?.language
        cell.tag = indexPath.row
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 画面遷移時に呼ばれる
        index = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
}
