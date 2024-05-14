//
//  HomeTableViewCell.swift
//  Rikkeify
//
//  Created by PearUK on 14/5/24.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var homeItemCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        homeItemCollectionView.register(UINib(nibName: "HomeItemCell", bundle: nil), forCellWithReuseIdentifier: "HomeItemCell")
    }
    
    func setCollectionViewDataSourceDelegate(_ view: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout, forRow row: Int) {
        homeItemCollectionView.dataSource = view
        homeItemCollectionView.delegate = view
        homeItemCollectionView.tag = row
        homeItemCollectionView.reloadData()
    }
}
