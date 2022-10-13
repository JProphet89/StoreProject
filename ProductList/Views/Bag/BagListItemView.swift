//
//  BagListItemView.swift
//  ProductList
//
//  Created by João Fonseca on 12/10/2022.
//

import Kingfisher
import SwiftUI

struct BagListItemView: View {
    @Environment(\.bagOperation) var bagOperation

    var item: BagItem

    var body: some View {
        VStack(alignment: .leading) {
            Text(item.product.title)
                .font(.headline)
                .padding(.init(horizontal: 20))
            ScrollView(.horizontal) {
                HStack {
                    imageViewFor(url: item.product.thumbnail)
                    ForEach(item.product.images, id: \.self) { image in
                        imageViewFor(url: image)
                    }
                }
            }
            .padding(.init(horizontal: 20))
            quantityManagingView
            
            Divider()
        }
        .accessibilityLabel("accessibilityBagListItem")
    }
    
    private var quantityManagingView: some View{
        HStack{
            Stepper("Quatity: \(item.quantity)", value: .init(get: { item.quantity }, set: { step in
                bagOperation?(.init(product: item.product, operation: step > item.quantity ? .add : .reduce))
            }), in: 0 ... item.product.stock, step: 1)
            .padding(.init(vertical: 16, horizontal: 20))
            Button {
                bagOperation?(.init(product: item.product, operation: .remove))
            } label: {
                HStack{
                    Image(systemName: "trash")
                        .foregroundColor(.white)
                    Text("Remove")
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(RemoveButton())
            .padding(.init(horizontal: 20))
        }
    }

    private func imageViewFor(url: String) -> some View {
        KFImage(URL(string: url))
            .placeholder { _ in
                Image(systemName: "photo")
                    .frame(width: 100, height: 100)
            }
            .resizable()
            .cacheMemoryOnly(false)
            .frame(width: 100, height: 100)
            .cornerRadius(5)
            .padding(.init(horizontal: 8))
            .clipShape(Rectangle())
    }
}

struct BagItemList_Previews: PreviewProvider {
    static var previews: some View {
        BagListItemView(item: .init(product: .empty))
    }
}
