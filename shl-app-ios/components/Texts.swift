//
//  Texts.swift
//  shl-app-ios
//
//  Created by Pål on 2021-07-30.
//

import SwiftUI

extension UIFont {
    class func rounded(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let systemFont = UIFont.systemFont(ofSize: size, weight: weight)

        guard #available(iOS 13.0, *), let descriptor = systemFont.fontDescriptor.withDesign(.rounded) else { return systemFont }
        return UIFont(descriptor: descriptor, size: size)
    }
}

extension Text {

    func listHeader(_ leading: Bool = true) -> some View {
        let txt = self
            .font(.system(size: 18, design: .rounded))
            .fontWeight(.semibold)
            .foregroundColor(Color(UIColor.secondaryLabel))
            .textCase(.uppercase)
        if (leading) {
            return txt
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 15)
        }
        return txt
            .frame(maxWidth: .none)
            .padding(.leading, 0)
    }
    
    func starred(_ starred: Bool) -> some View {
        return self.overlay(
            RoundedRectangle(cornerRadius: 2)
                .frame(height: 3).frame(maxWidth: starred ? .infinity : 0).offset(y: 1)
                .foregroundColor(Color(UIColor.systemYellow).opacity(starred ? 1 : 0)), alignment: .bottom)
            .animation(.easeInOut(duration: 0.2), value: starred)
    }
}

extension UIScreen {
    static var isMini: Bool {
        get {
            UIScreen.main.bounds.size.width <= 380
        }
    }
}

extension UIImage {
    func withSize(targetSize: CGSize) -> UIImage {
        // Draw and return the resized UIImage
        let scaledImage = UIGraphicsImageRenderer(size: targetSize).image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: targetSize
            ))
        }
        
        return scaledImage
    }
}
