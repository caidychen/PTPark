//
//  UISearchBar++.swift
//  Swift3Project
//
//  Created by Yilei on 7/4/17.
//  Copyright © 2017 lionhylra.com. All rights reserved.
//

import UIKit

extension UISearchBar {
    var isSearching: Bool {
        get {
            return isFirstResponder
        }
        set {
            if newValue {
                becomeFirstResponder()
            } else {
                resignFirstResponder()
            }
        }
    }

    var isSearchingWithNoneEmptySearchText: Bool {
        return isSearching && !(text ?? "").isEmpty
    }

    var hasNonEmptySearchText: Bool {
        return !(text ?? "").isEmpty
    }

}

class SearchBarSimpleDelegateObject: NSObject, UISearchBarDelegate {
    var textDidChangeHandler: ((UISearchBar, String) -> Void)?
    var searchButtonClicked: ((UISearchBar) -> Void)?

    init(textDidChangeHandler: ((UISearchBar, String) -> Void)?, searchButtonClicked: ((UISearchBar) -> Void)? = nil) {
        self.textDidChangeHandler = textDidChangeHandler
        self.searchButtonClicked = searchButtonClicked
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        textDidChangeHandler?(searchBar, searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.hacked.cancelButton?.isEnabled = true
        searchButtonClicked?(searchBar)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        textDidChangeHandler?(searchBar, "")
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if (searchBar.text ?? "").isEmpty {
            searchBar.setShowsCancelButton(false, animated: true)
        }
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
}
