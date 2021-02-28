//
//  NoteCollectionViewCell.swift
//  Notes
//
//  Created by Gopinath.A on 27/02/21.
//

import UIKit

class NoteCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.black.withAlphaComponent(0.6)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Constraint
    private func setupConstraint(){
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            titleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 12),
            titleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -12),
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),
            dateLabel.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor),
            dateLabel.rightAnchor.constraint(equalTo: self.titleLabel.rightAnchor),
        ])
    }
    
    // MARK: - Setup UI
    func setupUI(note: Note) {
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(dateLabel)
        self.contentView.backgroundColor = colors.randomElement()
        self.contentView.layer.cornerRadius = 10
        
        setupConstraint()
        
        titleLabel.text = note.title
        dateLabel.text = note.time?.getDate()
        if note.image == nil{
            titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            dateLabel.textAlignment = .left
        }else{
            titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            dateLabel.textAlignment = .right
        }
        
    }
    
}
