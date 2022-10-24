//
//  FeedCover.swift
//  MovieAgendaSwiftUI
//
//  Created by Ricardo Venieris on 24/10/22.
//

import SwiftUI

struct FeedCover: View {
    var url:URL?
    var title:String
    
    var body: some View {
        ZStack {
//            Rectangle().background {Color.red}.aspectRatio(9/16, contentMode: .fit)
            VStack {
                CustomAsyncImage(imageURL: url)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top, 30)
                Spacer()
            }
            VStack {
                Text(title)
                    .padding()
                    .multilineTextAlignment(.center)
                    .font(.callout.bold())
                    .foregroundColor(.blue)
                    .background(Color.white, in: RoundedRectangle(cornerRadius: 5))
                    .shadow(color: Color.blue.opacity(0.3), radius: 10)
                Spacer()
            }
        }
    }
}

struct FeedCover_Previews: PreviewProvider {
    static var previews: some View {
        FeedCover(url: URL(string: "https://br.web.img3.acsta.net/medias/nmedia/18/90/90/21/20119166.jpg"),
        title: "O Guia do Mochileiro das Galáxias")
    }
}
