//
//  BackgroundImageView.swift
//  Devotion
//
//  Created by adam janusewski on 5/10/22.
//

import SwiftUI

struct BackgroundImageView: View {
    var body: some View {
        Image("")
            .antialiased(true)
            .resizable()
            .scaledToFit()
            .ignoresSafeArea(.all)
    }
}

struct BackgroundImageView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundImageView()
    }
}
