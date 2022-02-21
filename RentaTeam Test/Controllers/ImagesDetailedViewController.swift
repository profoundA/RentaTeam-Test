//
//  ImagesDetailedViewController.swift
//  RentaTeam Test
//
//  Created by Andrey Lobanov on 21.02.2022.
//

import UIKit
import SnapKit

class ImagesDetailedViewController: UIViewController {
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .black)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .black)
        return label
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Закрыть", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .black)
        button.tintColor = .black
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 20
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(photoImageView)
        view.addSubview(nameLabel)
        view.addSubview(dateLabel)
        view.addSubview(closeButton)
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - SetupConstraints
extension ImagesDetailedViewController {
    func setupConstraints() {
        photoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(300)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(dateLabel).inset(30)
            make.left.equalToSuperview().inset(10)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(closeButton).inset(80)
            make.left.equalToSuperview().inset(10)
        }
        
        closeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(30)
            make.height.equalTo(40)
            make.width.equalTo(150)
        }
    }
}
