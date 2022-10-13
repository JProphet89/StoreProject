//
//  ProductListView.swift
//  ProductList
//
//  Created by João Fonseca on 12/10/2022.
//

import Kingfisher
import SwiftUI

struct ProductListView: View {
    @Environment(\.addProduct) var addProduct
    var product: Product
    
    var body: some View {
        HStack {
            imageView
            detailsProductView
            addButtonView
        }
        .frame(height: 120)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black.opacity(0.2), lineWidth: 1)
        )
        .background(
            RoundedRectangle(
                cornerRadius: 10
            )
            .foregroundColor(Color.white)
            .shadow(
                color: Color.gray,
                radius: 2,
                x: 0,
                y: 0
            )
        )
    }
    
    //MARK: - subviews extracted
    
    private var imageView: some View {
        VStack {
            KFImage(URL(string: product.thumbnail))
                .placeholder { _ in
                    Image(systemName: "photo")
                        .frame(width: 100, height: 100)
                }
                .resizable()
                .cacheMemoryOnly(false)
                .frame(width: 100, height: 100)
                .cornerRadius(5)
                .clipShape(Rectangle())
        }
        .frame(width: 105)
    }
    
    private var detailsProductView: some View{
        VStack(alignment: .leading) {
            Text(product.title)
                .font(.headline)
            Text(product.description)
                .font(.caption2)
            Spacer()
            HStack{
                VStack(alignment: .leading){
                    Text("Rating:\(product.rating, specifier: "%.1f")")
                        .font(.caption2)
                    Text("Price: \(product.price, specifier: "%.2f")€")
                        .font(.caption)
                }
                Spacer()
                HStack{
                    Text("Stock:")
                        .font(.caption2)
                    Image(systemName: "button.programmable")
                        .foregroundColor(product.stock > 0 ? .green : .red)
                }
            }
            
        }
        .padding(10)
        .fullExpand()
    }
    
    private var addButtonView: some View {
        VStack {
            Spacer()
            Button(action: {
                addProduct?(product)
            }) {
                Image(systemName: "cart.badge.plus")
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.black)
                    .clipShape(Circle())
                    .background(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )
            }.accessibilityLabel("accessibilityProductAddButton")
            Spacer()
        }
        .padding(10)
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView(product: .init(id: 0, title: "title", description: "description", price: 99.9, discountPercentage: 15.0, rating: 5, stock: 2, brand: "brand", category: "category", thumbnail: "thumbnail", images: []))
    }
}
