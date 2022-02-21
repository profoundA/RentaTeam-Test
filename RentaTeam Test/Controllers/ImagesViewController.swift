//
//  ImagesViewController.swift
//  RentaTeam Test
//
//  Created by Andrey Lobanov on 21.02.2022.
//

import UIKit
import SnapKit
import SDWebImage

class ImagesViewController: UIViewController {
    
    var photos = [Hit]()
    
    var dateArray = [Date]()
    
    private var pageNumber = 1
    
    private var loadMore = false
    
    private let itemsPerRow: CGFloat = 2
    
    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Фотографии"
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var collectionView: UICollectionView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Networking.shared.fetchPhotos(page: pageNumber) { result in
            self.photos = result
            self.collectionView?.reloadData()
        }
        setupView()
        setupDelegates()
        setupConstraints()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(headerLabel)
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.itemSize = CGSize(width: (view.frame.size.width/3) - 4,
                                 height: (view.frame.size.width/3 - 4))
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let collectionView = collectionView else { return }
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "imageCell")
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
    }
    
    private func setupDelegates() {
        collectionView?.delegate = self
        collectionView?.dataSource = self
    }
    
    private func beginLoad() {
        loadMore = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.pageNumber += 1
            Networking.shared.fetchPhotos(page: self.pageNumber) { result in
                self.photos.append(contentsOf: result)
                self.loadMore = false
                self.collectionView?.reloadData()
                for _ in 0...self.photos.count - 1 {
                    self.dateArray += [Date()]
                }
                UserDefaults.standard.setValue(self.dateArray, forKey: "date")
                UserDefaults.standard.synchronize()
            }
        }
    }
}

//MARK: - UICollectionViewDataSource

extension ImagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageCell else {
            return UICollectionViewCell()
        }
        let photo = photos[indexPath.row]
        
        
        cell.photoImageView.sd_setImage(with: URL(string: photo.largeImageURL), completed: nil)
        cell.nameLabel.text = "Фотограф: @\(photo.user)"
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ImagesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        guard let date = UserDefaults.standard.array(forKey: "date")?[indexPath.row] else { return }
       
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.y"
        let stringDate = formatter.string(from: date as! Date)
        
        let detailedVC = ImagesDetailedViewController()
        if #available(iOS 13.0, *) {
            detailedVC.isModalInPresentation = true
        } 
        detailedVC.photoImageView.sd_setImage(with: URL(string: photo.largeImageURL), completed: nil)
        detailedVC.nameLabel.text = "Фотограф: @\(photo.user)"
        detailedVC.dateLabel.text = "Впервые открыто: \(stringDate)"
        present(detailedVC, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !loadMore {
                beginLoad()
            }
        }
    }
}

// MARK: - SetupConstraints

extension ImagesViewController {
    private func setupConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview().inset(10)
            make.height.equalTo(35)
            make.width.equalTo(200)
        }
        
        collectionView?.snp.makeConstraints { make in
            make.top.equalTo(headerLabel).inset(40)
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
}
// MARK: - UICollectionViewDelegateFlowLayout

extension ImagesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = photos[indexPath.item]
        let paddingSpace = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let height = CGFloat(photo.imageHeight) * widthPerItem / CGFloat(photo.imageWidth)
        return CGSize(width: widthPerItem, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
}
