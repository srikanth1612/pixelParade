//
//  SupportFiles.swift
//  pixelparadeiMessage
//
//  Created by Chethan Jayaram on 12/11/24.
//

import UIKit

/// Shortcuts for screen size constants
struct Screen {
    
    /// Screen width: returns UIScreen.main.bounds.width
    static var width: CGFloat { return UIScreen.main.bounds.width }
    
    /// Screen height: returns UIScreen.main.bounds.height
    static var height: CGFloat { return UIScreen.main.bounds.height }
    
    /// Screen bounds: returns UIScreen.main.bounds
    static var bounds: CGRect { return UIScreen.main.bounds }
    
    /// Hardcoded default tab bar height; always 49 since iOS7
    static var tabBarHeight: CGFloat { return 49 }
    
    /// Hardcoded default navigation bar height; always 44 since iOS7
    static var navigationBarHeight: CGFloat { return 44 }
    
    /// Current status bar height. The value changes in modem mode and in audio recording mode. Default height is 20
    static var statusBarHeight: CGFloat { return 20 }
    
    static var scale: CGFloat { return UIScreen.main.scale }
    
    static var widthScale: CGFloat { return self.width / 375 }
    
    static var heightScale: CGFloat { return self.height / 667 }
    
    static var separatorHeight: CGFloat { return 1 / self.scale }
}

struct TableView {
    
    static var estimatedRowHeight: CGFloat { return 44 }
    
    static var estimatedHeaderFooterHeight: CGFloat { return 44 }
    
}



public func runThisAfterDelay(seconds: Double, after: @escaping () -> Void) {
    runThisAfterDelay(seconds: seconds, queue: DispatchQueue.main, after: after)
}

public func runThisAfterDelay(seconds: Double, queue: DispatchQueue, after: @escaping () -> Void) {
    let time = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    queue.asyncAfter(deadline: time, execute: after)
}

public func runThisInMainThread(_ block: @escaping () -> Void) {
    DispatchQueue.main.async(execute: block)
}

public func runThisInBackground(_ block: @escaping () -> Void) {
    DispatchQueue.global(qos: .default).async(execute: block)
}

