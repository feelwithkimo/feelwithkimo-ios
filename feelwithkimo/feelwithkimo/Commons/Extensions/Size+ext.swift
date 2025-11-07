//
//  Size+ext.swift
//  feelwithkimo
//
//  Created by Richard Sugiharto on 30/10/25.
//
import SwiftUI

extension CGFloat {
    /// Function to dynamic width based on Ipad 11" design (1194 x 834)
    func getWidth(byBaseWidth baseWidth: CGFloat = 1194) -> CGFloat {
        return self * UIScreen.main.bounds.width / baseWidth
    }
    
    /// Function to dynamic height based on Ipad 11" design (1194 x 834)
    func getHeight(byBaseHeight baseHeight: CGFloat = 834) -> CGFloat {
        return self * UIScreen.main.bounds.height / baseHeight
    }
    
    /// Function to dynamic width based on Ipad 13" design (1366 x 1024)
    func getWidth13(byBaseWidth baseWidth: CGFloat = 1366) -> CGFloat {
        return self * UIScreen.main.bounds.width / baseWidth
    }
    
    /// Function to dynamic height based on Ipad 13" design (1366 x 1024)
    func getHeight13(byBaseHeight baseHeight: CGFloat = 1024) -> CGFloat {
        return self * UIScreen.main.bounds.height / baseHeight
    }
    
    /// Function to get adaptive width based on current device
    /// Automatically uses iPad 13" base if screen is larger, otherwise iPad 11"
    func getAdaptiveWidth() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        if screenWidth >= 1366 {
            return self.getWidth13()
        } else {
            return self.getWidth()
        }
    }
    
    /// Function to get adaptive height based on current device
    /// Automatically uses iPad 13" base if screen is larger, otherwise iPad 11"
    func getAdaptiveHeight() -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        if screenHeight >= 1024 {
            return self.getHeight13()
        } else {
            return self.getHeight()
        }
    }
}

extension BinaryInteger {
    /// Function to dynamic width based on Ipad 11" design (1194 x 834)
    func getWidth(byBasedWidth baseWidth: CGFloat = 1194) -> CGFloat {
        return CGFloat(self) * UIScreen.main.bounds.width / baseWidth
    }
    
    /// Function to dynamic height based on Ipad 11" design (1194 x 834)
    func getHeight(byBaseHeight baseHeight: CGFloat = 834) -> CGFloat {
        return CGFloat(self) * UIScreen.main.bounds.height / baseHeight
    }
    
    /// Function to dynamic width based on Ipad 13" design (1366 x 1024)
    func getWidth13(byBaseWidth baseWidth: CGFloat = 1366) -> CGFloat {
        return CGFloat(self) * UIScreen.main.bounds.width / baseWidth
    }
    
    /// Function to dynamic height based on Ipad 13" design (1366 x 1024)
    func getHeight13(byBaseHeight baseHeight: CGFloat = 1024) -> CGFloat {
        return CGFloat(self) * UIScreen.main.bounds.height / baseHeight
    }
    
    /// Function to get adaptive width based on current device
    /// Automatically uses iPad 13" base if screen is larger, otherwise iPad 11"
    func getAdaptiveWidth() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        if screenWidth >= 1366 {
            return self.getWidth13()
        } else {
            return self.getWidth()
        }
    }
    
    /// Function to get adaptive height based on current device
    /// Automatically uses iPad 13" base if screen is larger, otherwise iPad 11"
    func getAdaptiveHeight() -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        if screenHeight >= 1024 {
            return self.getHeight13()
        } else {
            return self.getHeight()
        }
    }
}
