//
//  ImageCell.swift
//  RentaTeam Test
//
//  Created by Andrey Lobanov on 21.02.2022.
//

import UIKit
import SnapKit

class ImageCell: UICollectionViewCell {
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "stat"
        label.font = UIFont.systemFont(ofSize: 9, weight: .heavy)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .lightText
        self.addSubview(photoImageView)
        self.addSubview(nameLabel)
    }
    
    private func setupConstraints() {
        photoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(10)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.safeAreaLayoutGuide.snp.centerX)
            make.left.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(15)
            make.bottom.equalToSuperview().offset(2)
        }
    }
}

