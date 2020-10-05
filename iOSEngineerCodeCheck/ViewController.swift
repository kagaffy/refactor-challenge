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

    private var searchResult: SearchResult?
    private var task: GitHubAPIService?

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.placeholder = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        task?.cancel()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let term = searchBar.text ?? ""
        guard !term.isEmpty else { return }

        task = GitHubAPIService()
        task?.request(by: term, onSuccess: { [weak self] searchResult in
            self?.searchResult = searchResult
            self?.tableView.reloadData()
        }, onError: { error in
            print(error)
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            guard let vc = segue.destination as? ViewController2 else {
                assertionFailure()
                return
            }
            vc.repository = sender as? Repository
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResult?.repositories.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let repo = searchResult?.repositories[indexPath.row]
        cell.textLabel?.text = repo?.name
        cell.detailTextLabel?.text = repo?.language
        cell.tag = indexPath.row
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repo = searchResult?.repositories[indexPath.row]
        performSegue(withIdentifier: "Detail", sender: repo)
    }
}
