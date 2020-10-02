//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var SchBr: UISearchBar!

    var repo: [[String: Any]] = []

    var task: URLSessionTask?
    var word: String = ""
    var url: String = ""
    var idx: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SchBr.text = "GitHubのリポジトリを検索できるよー"
        SchBr.delegate = self
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // ↓こうすれば初期のテキストを消せる
        searchBar.text = ""
        return true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        task?.cancel()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        word = searchBar.text ?? ""

        if word.count != 0 {
            url = "https://api.github.com/search/repositories?q=\(word)"
            guard let url = URL(string: url) else { return }
            task = URLSession.shared.dataTask(with: url) { [weak self] data, _, err in
                if let err = err {
                    print(err)
                    return
                }
                guard let data = data else { return }
                do {
                    if let obj = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        if let items = obj["items"] as? [[String: Any]] {
                            self?.repo = items
                            DispatchQueue.main.async {
                                self?.tableView.reloadData()
                            }
                        }
                    }
                } catch {
                    print(error)
                }
            }
            // これ呼ばなきゃリストが更新されません
            task?.resume()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            guard let dtl = segue.destination as? ViewController2 else {
                assertionFailure()
                return
            }
            dtl.vc1 = self
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repo.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let rp = repo[indexPath.row]
        cell.textLabel?.text = rp["full_name"] as? String ?? ""
        cell.detailTextLabel?.text = rp["language"] as? String ?? ""
        cell.tag = indexPath.row
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 画面遷移時に呼ばれる
        idx = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
}
