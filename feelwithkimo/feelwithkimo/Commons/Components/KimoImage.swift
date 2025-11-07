//
//  KimoImage.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 06/11/25.
//

import SwiftUI

struct KimoImage: View {
    var imagePath: String = ""
    var width: CGFloat
    var height: CGFloat?
    
    init(image: String, width: CGFloat) {
        self.imagePath = image
        self.width = width
    }
    
    var body: some View {
        Image(imagePath)
            .resizable()
            .scaledToFit()
            .frame(width: width)
    }
}
