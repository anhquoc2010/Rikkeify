//
//  SearchVC.swift
//  Rikkeify
//
//  Created by QuocLA on 20/05/2024.
//

import UIKit

class SearchVC: UIViewController {
    // MARK: Properties
    private var viewModel: SearchVM
    
    // MARK: Outlets
    @IBOutlet private weak var categoryCollectionView: UICollectionView!
    @IBOutlet private weak var sectionTitleLabel: UILabel!
    
    // MARK: Lifecycle
    init() {
        viewModel = SearchVM()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupListViews()
        bindViewModel()
    }

    @IBAction func onSearchFieldTapped(_ sender: Any) {
        navigationController?.pushViewController(SearchActiveVC(), animated: false)
    }
}

extension SearchVC {
    private func setupViews() {
        
    }
    
    private func setupListViews() {
        self.categoryCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        self.categoryCollectionView.dataSource = self
        self.categoryCollectionView.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.fetchCategories() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.categoryCollectionView.reloadData()
                }
            case .failure(let error):
                self.showAlert(title: error.customMessage.capitalized, message: "")
            }
        }
    }
}

extension SearchVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell else { return .init() }
        cell.configure(category: viewModel.categories[indexPath.item])
        return cell
    }
}

extension SearchVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        let space = flowLayout.minimumInteritemSpacing + flowLayout.sectionInset.left * 2
        let size = (collectionView.frame.size.width - space) / 2.0
        return .init(width: size, height: size * 1.75 / 3.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let genre = viewModel.categories[indexPath.row]
        let vc = GenreVC(genreId: genre.id, title: genre.title)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
