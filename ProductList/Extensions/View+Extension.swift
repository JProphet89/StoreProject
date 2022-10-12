//
//  View+Extension.swift
//  ProductList
//
//  Created by João Fonseca on 11/10/2022.
//
import SwiftUI

extension View {
    func fullExpand() -> some View {
        frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
        )
    }
}


extension UINavigationController{
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backButtonDisplayMode = .minimal
    }
}
