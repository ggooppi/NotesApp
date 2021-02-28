//
//  PhotoCollectionViewCell.swift
//  Notes
//
//  Created by Gopinath.A on 01/03/21.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setupUI()
    }
    
    // MARK: - Properties
    lazy var photo: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = false
        imageView.image = UIImage(named: "background")
        return imageView
    }()
    
    private func setupUI() {
        self.contentView.addSubview(photo)
        
        NSLayoutConstraint.activate([
            photo.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            photo.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            photo.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            photo.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
        ])
        
    }
}
