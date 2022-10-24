    //
    //  CustomAsyncImage.swift
    //  MovieAgendaSwiftUI
    //
    //  Created by Ricardo Venieris on 23/10/22.
    //

import SwiftUI

struct CustomAsyncImage: View {
    var imageURL:URL?
    var body: some View {
        AsyncImage(url: imageURL) { phase in
            switch phase {
                case .success(let image):
                    image.resizable().scaledToFit()
                case .failure:
                    errorImage.resizable().scaledToFit()
                case .empty:
                    Rectangle().foregroundColor(.clear).overlay {
                        ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    }.aspectRatio(1, contentMode: .fit)
                @unknown default:
                    errorImage
            }
        }
    }
    
    var errorImage = Image(systemName: "exclamationmark.circle")
    
}

struct CustomAsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        CustomAsyncImage(imageURL: URL(string: "https://i.pinimg.com/564x/be/5a/83/be5a836e0f1e8c14a6118584c8076398--galaxy-movie-the-galaxy.jpg"))
    }
}
