//
//  RITLPhotosBottomBar.swift
//  RITLImagePicker-Swift
//
//  Created by YueWen on 2021/4/15.
//  Copyright © 2021 YueWen. All rights reserved.
//

import UIKit

/// 底部的功能栏
public class RITLPhotosBottomBar: UIView {
    
    /// 预览按钮
    lazy var previewButton: UIButton = {
        
        let button = UIButton()
        button.isEnabled = false
        button.adjustsImageWhenHighlighted = false
        button.titleLabel?.font = RITLPhotoFont.regular.font(size: 15)
        
        button.setTitle("预览", for: .normal)
        button.setTitle("预览", for: .disabled)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.4117647059, green: 0.4274509804, blue: 0.4431372549, alpha: 1), for: .disabled)
        
        return button
    }()
    
    /// 原图按钮
    lazy var highButton: UIButton = {
        
        let button = UIButton()
        
        var titleEdgeLeft: CGFloat = (UIDevice.current.systemVersion as NSString).floatValue < 13 ? -60 : 0
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 42)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: titleEdgeLeft, bottom: 0, right: 0)
        button.adjustsImageWhenHighlighted = false
        button.titleLabel?.font = RITLPhotoFont.regular.font(size: 15)
        
        button.setTitle("原图", for: .normal)
        button.setTitle("原图", for: .selected)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1), for: .disabled)
        button.setImage(RITLPhotosImage.tool_bottom_deselect.image, for: .normal)
        button.setImage(RITLPhotosImage.tool_bottom_selecte.image, for: .selected)
//        button.imageView?.contentMode = .scaleToFill
        
        return button
    }()
    
    
    /// 发送按钮
    lazy var sendButton: UIButton = {
        
        let button = UIButton()
        button.isEnabled = false
        button.adjustsImageWhenHighlighted = false
        button.titleLabel?.font = RITLPhotoFont.regular.font(size: 14)
        
        button.setTitle("发送", for: .normal)
        button.setTitle("发送", for: .disabled)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1), for: .disabled)
        button.setBackgroundImage(#colorLiteral(red: 0.03529411765, green: 0.7333333333, blue: 0.3529411765, alpha: 1).ritl_p_image, for: .normal)
        button.setBackgroundImage(#colorLiteral(red: 0.1764705882, green: 0.1764705882, blue: 0.1764705882, alpha: 1).ritl_p_image, for: .disabled)
        
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        
        return button
    }()
    private var sendButtonDidAdjust = false
    
    /// 底部的toolbar
//    private let toolBar = UIToolbar()
    private let toolBar = UIView()
    

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        toolBar.backgroundColor = 35.ritl_p_color.withAlphaComponent(0.7)

        let itemsContentView = UIView()
        itemsContentView.backgroundColor = .clear
        
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        
        addSubview(toolBar)
        toolBar.addSubview(effectView)
        addSubview(itemsContentView)
        itemsContentView.addSubview(previewButton)
        itemsContentView.addSubview(highButton)
        itemsContentView.addSubview(sendButton)

        toolBar.ritl_photos_anchorEdge(to: self)
//        toolBar.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
        
        effectView.ritl_photos_anchorEdge(to: toolBar)
//        effectView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }

        itemsContentView.translatesAutoresizingMaskIntoConstraints = false
        itemsContentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        itemsContentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        itemsContentView.heightAnchor.constraint(equalToConstant: RITLPhotoBarDistance.tabBar.normalHeight).isActive = true
        itemsContentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1 * RITLPhotoBarDistance.tabBar.safeDistance).isActive = true
        
//        itemsContentView.snp.makeConstraints { (make) in
//            make.leading.trailing.equalToSuperview()
//            make.height.equalTo(RITLPhotoBarDistance.tabBar.normalHeight)
//            make.bottom.equalToSuperview().inset(RITLPhotoBarDistance.tabBar.safeDistance)
//        }

        previewButton.translatesAutoresizingMaskIntoConstraints = false
        previewButton.leadingAnchor.constraint(equalTo: itemsContentView.leadingAnchor, constant: 12).isActive = true
        previewButton.centerYAnchor.constraint(equalTo: itemsContentView.centerYAnchor).isActive = true
        previewButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
//        previewButton.snp.makeConstraints { (make) in
//            make.leading.equalToSuperview().offset(12)
//            make.centerY.equalToSuperview()
//            make.width.equalTo(60)
//        }

        highButton.translatesAutoresizingMaskIntoConstraints = false
        highButton.centerYAnchor.constraint(equalTo: itemsContentView.centerYAnchor).isActive = true
        highButton.centerXAnchor.constraint(equalTo: itemsContentView.centerXAnchor).isActive = true
        highButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        highButton.heightAnchor.constraint(equalToConstant: 33).isActive = true
        
//        highButton.snp.makeConstraints { (make) in
//            make.centerY.equalToSuperview()
//            make.centerX.equalToSuperview()
//            make.width.equalTo(60)
//            make.height.equalTo(33)
//        }
        
        sendButton.frame = CGRect(x: 0, y: 0, width: 0, height: 30)
        sendButton.frame.size.width = 65
    }
    
    /// 更新发送按钮
    func updateSendButton() {
        /// 发送按钮
        let size = sendButton.sizeThatFits(CGSize(width: 100, height: 100))
        sendButton.frame.size = CGSize(width: max(size.width + 30, 65) , height: 30)
        sendButton.frame.origin.x = frame.size.width - sendButton.frame.size.width - 14
        sendButton.center.y = highButton.center.y
    }
    
    
    func updateToolBackgroundColor(color: UIColor) {
        toolBar.backgroundColor = color
    }
    
    
    public override func layoutSubviews() {
        //默认调整
        sendButton.center.y = highButton.center.y
        guard !sendButtonDidAdjust else { return }
        updateSendButton()
        sendButtonDidAdjust = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        ritl_p_print("\(type(of: self)) is deinit")
    }
}
