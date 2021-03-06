//
//  RITLPhotosUtilites.swift
//  RITLImagePicker-Swift
//
//  Created by YueWen on 2021/4/14.
//  Copyright © 2021 YueWen. All rights reserved.
//

import UIKit


public extension UIColor {
    
    /// 生成图片
    var ritl_p_image : UIImage {
        
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    
    /// 混合色，默认0.5为中间色
    
    
    /// 混合色,不合规返回.white
    /// - Parameters:
    ///   - color: 第二种颜色
    ///   - percent: 默认0.5为中间色, color参数的比例
    func ritl_p_blend(color: UIColor = .white, percent: Double = 0.5) -> UIColor {
        
        //自己的色值
        let fromRed = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        let fromGreen = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        let fromBlue = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        let fromAlpha = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        
        defer {
            fromRed.deallocate()
            fromGreen.deallocate()
            fromBlue.deallocate()
            fromAlpha.deallocate()
        }
        
        if !getRed(fromRed, green: fromGreen, blue: fromBlue, alpha: fromAlpha) {
            return .white
        }
        
        //Ro
        let toRed = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        let toGreen = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        let toBlue = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        let toAlpha = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        
        
        defer {
            toRed.deallocate()
            toGreen.deallocate()
            toBlue.deallocate()
            toAlpha.deallocate()
        }
        
        if !color.getRed(toRed, green: toGreen, blue: toBlue, alpha: toAlpha) {
            return .white
        }
        
        //计算
        let newRed = fromRed.pointee + (toRed.pointee - fromRed.pointee) * CGFloat(fmin(1, percent))
        let newGreen = fromGreen.pointee + (toGreen.pointee - fromGreen.pointee) * CGFloat(fmin(1, percent))
        let newBlue = fromBlue.pointee + (toBlue.pointee - fromBlue.pointee) * CGFloat(fmin(1, percent))
        let newAlpha = fromAlpha.pointee + (toAlpha.pointee - fromAlpha.pointee) * CGFloat(fmin(1, percent))
        
        return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: newAlpha)
    }
}


public extension Int{
    
    /// 生成颜色
    var ritl_p_color: UIColor {
        
        if self < 0 { return .black }
        let color = self.ritl_p_colorBrightness
        return UIColor(red: color, green: color, blue: color, alpha: 1)
    }
    
    /// 生成图片
    var ritl_p_image : UIImage {
        return self.ritl_p_color.ritl_p_image
    }
    
    
    /// 颜色的色值，self/255.0
    var ritl_p_colorBrightness: CGFloat {
        
        if self < 0 || self > 255 { return 0 }
        return CGFloat(self) / 255
    }

    
    /// 生成size
    var ritl_p_size: CGSize {
        guard self > 0 else { return .zero }
        return CGSize(width: self, height: self)
    }
}



final class RITLPhotosPhoneHeaderUtility: NSObject {
    /// 默认值为空字符串
    static var hasPhoneHeaderStatus = ""
    
    static func setHasNotPhoneHeader() {
        RITLPhotosPhoneHeaderUtility.hasPhoneHeaderStatus = "0"
    }
    
    static func setHasPhoneHeader() {
        RITLPhotosPhoneHeaderUtility.hasPhoneHeaderStatus = "1"
    }
    
    static func hasPhoneHeader() -> Bool {
        return RITLPhotosPhoneHeaderUtility.hasPhoneHeaderStatus == "1"
    }
    
    /// 状态栏高度缓存
    static var statusBarHeight: CGFloat = {
        guard ritl_photo_hasPhoneHeader() else { return 20 }
        guard let window = UIApplication.shared.windows.first else { return 20 }
        if #available(iOS 11.0, *) {
            return window.safeAreaInsets.top
        } else {
            // Fallback on earlier versions
            return 20
        }
    }()
}


/// 刘海屏判断
public func ritl_photo_hasPhoneHeader() -> Bool {
    //如果缓存为空，进行判断
    guard RITLPhotosPhoneHeaderUtility.hasPhoneHeaderStatus.isEmpty else {
        return RITLPhotosPhoneHeaderUtility.hasPhoneHeader()
    }
    
    //安全
    guard #available(iOS 11.0, *) else { RITLPhotosPhoneHeaderUtility.setHasNotPhoneHeader(); return false }
    
    //返回
    guard let window = UIApplication.shared.windows.first else { RITLPhotosPhoneHeaderUtility.setHasNotPhoneHeader(); return false }
    //获得底部的间距
    let bottom = window.safeAreaInsets.bottom
    

    if bottom > 0 {
        RITLPhotosPhoneHeaderUtility.setHasPhoneHeader()
    } else {
        RITLPhotosPhoneHeaderUtility.setHasNotPhoneHeader()
    }
    return RITLPhotosPhoneHeaderUtility.hasPhoneHeader()
}


/// 状态栏的高度
public func ritl_photo_statusBarHeight() -> CGFloat {
    return RITLPhotosPhoneHeaderUtility.statusBarHeight
}



public enum RITLPhotoBarDistance {
    case navigationBar
    case tabBar
}


public extension RITLPhotoBarDistance {
    
    /// 正常情况下的高度
    var normalHeight: CGFloat {
        switch self {
        case .navigationBar:
            return 64
        case .tabBar:
            return 49
        }
    }
    
    
    /// 默认高度
    var height: CGFloat {
        switch self {
        case .navigationBar:
            return 44 + ritl_photo_statusBarHeight()
        case .tabBar:
            return ritl_photo_hasPhoneHeader() ? 83 : 49
        }
    }
    
    /// 安全间隔
    var safeDistance: CGFloat {
        switch self {
        case .navigationBar:
            return ritl_photo_statusBarHeight() - 20
        case .tabBar:
            return ritl_photo_hasPhoneHeader() ? 83 - 49 : 0
        }
    }
}



/// 字体
public enum RITLPhotoFont: String {
    
    case regular = "PingFangSC-Regular"
    case medium = "PingFangSC-Medium"
    case bold = "PingFangSC-Bold"
    case light = "PingFangSC-Light"
    case semibold = "PingFangSC-Semibold"
}


public extension RITLPhotoFont {
    func font(size: CGFloat) -> UIFont {
        return UIFont.ritl_p_font(name: self.rawValue, size: size)
    }
}


public extension UIFont {
    
    /// 根据字体名字获取font对象，如果不存在，返回系统默认字体
    ///
    /// - Parameters:
    ///   - name: 字体类型
    ///   - size: 字体大小
    class func ritl_p_font(name: String, size: CGFloat) -> UIFont{
        if let font = UIFont(name: name, size: size) {
            return font
        }
        return UIFont.systemFont(ofSize: size)
    }
}


public extension UICollectionView {
    
    func ritl_p_indexPathsForElements(in rect: CGRect) -> [IndexPath] {
        return collectionViewLayout.layoutAttributesForElements(in: rect)?.map{ $0.indexPath } ?? []
    }
}

// MARK: Log
func ritl_p_print<T>(_ msg: T,
    file: NSString = #file,
    line: Int = #line,
    fn: String = #function) {
    #if DEBUG
    let prefix = "\(file.lastPathComponent)_\(line)_\(fn):"
    print(prefix, msg)
    #endif
}


extension Optional {
    
    func ritl_photo_withExtendedLifetime(body: (Wrapped) -> (Void)) {
        if let strongSelf = self {
            body(strongSelf)
        }
    }
}


extension UIView {
    
    /// 相当于 edges.equalTo(view)
    func ritl_photos_anchorEdge(to view: UIView) {
        
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
