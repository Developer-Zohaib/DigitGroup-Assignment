//
//  AvatarImageView.swift
//  DigitGroup-Assignment
//
//  Created by zohaib afzal on 24/12/2025.
//

import UIKit

class AvatarImageView: UIView {
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = AppColors.separator
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let onlineIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.onlineStatus
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private var size: CGFloat
    
    init(size: CGFloat = Layout.AvatarSize.md, showOnlineIndicator: Bool = false) {
        self.size = size
        super.init(frame: .zero)
        setupView(showOnlineIndicator: showOnlineIndicator)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(showOnlineIndicator: Bool) {
        addSubview(imageView)
        addSubview(onlineIndicator)
        
        imageView.layer.cornerRadius = size / 2
        onlineIndicator.layer.cornerRadius = size * 0.15 / 2
        onlineIndicator.isHidden = !showOnlineIndicator
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: size),
            imageView.heightAnchor.constraint(equalToConstant: size),
            
            onlineIndicator.widthAnchor.constraint(equalToConstant: size * 0.15),
            onlineIndicator.heightAnchor.constraint(equalToConstant: size * 0.15),
            onlineIndicator.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            onlineIndicator.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            
            trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
        ])
    }
    
    func setImage(_ image: UIImage?) {
        imageView.image = image
    }
    
    func setOnlineStatus(_ isOnline: Bool) {
        onlineIndicator.isHidden = !isOnline
    }
}
