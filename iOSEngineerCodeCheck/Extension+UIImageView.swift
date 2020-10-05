//
//  Extension+UIImageView.swift
//  iOSEngineerCodeCheck
//
//  Created by Yoshiki Tsukada on 2020/10/05.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

extension UIImageView: ImageUploder {}

protocol ImageUploder: AnyObject {
    func setImage(of urlString: String)
}

extension ImageUploder where Self: UIImageView {
    func setImage(of urlString: String) {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, err in
            if let err = err {
                print(err)
                return
            }
            guard let data = data else { return }
            if let img = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = img
                }
            }
        }.resume()
    }
}
