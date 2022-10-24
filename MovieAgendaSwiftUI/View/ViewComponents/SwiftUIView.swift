//
//  SwiftUIView.swift
//  MovieAgendaSwiftUI
//
//  Created by Ricardo Venieris on 24/10/22.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        Rectangle().foregroundColor(.clear).overlay {
            ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .blue))
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
