//
//  Size+ext.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 30/10/25.
//
import SwiftUI

extension CGFloat {
    /// Function to dynamic width based on Ipad 11" design
    func getWidth(byBaseWidth baseWidth: CGFloat = 1194) -> CGFloat {
        return self * UIScreen.main.bounds.width / baseWidth
    }
    
    /// Function to dynamic height based on Ipad 11" design
    func getHeight(byBaseHeight baseHeight: CGFloat = 834) -> CGFloat {
        return self * UIScreen.main.bounds.height / baseHeight
    }
}

extension BinaryInteger {
    func getWidth(byBasedWidth baseWidth: CGFloat = 1194) -> CGFloat {
        return CGFloat(self) * UIScreen.main.bounds.width / baseWidth
    }
    
    /// Function to dynamic height based on Ipad 11" design
    func getHeight(byBaseHeight baseHeight: CGFloat = 834) -> CGFloat {
        return CGFloat(self) * UIScreen.main.bounds.height / baseHeight
    }
}
