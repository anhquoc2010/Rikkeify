//
//  HomeVC.swift
//  Rikkeify
//
//  Created by QuocLA on 15/04/2024.
//

import UIKit

// Constants
private let kNumberOfRowsInSection = 1
private let kHeightForHeaderInSectionTableView = 64.0
private let kWidthForCollectionViewCell = 164.0
private let kHeightForCollectionViewCell = kWidthForCollectionViewCell + 0.3 * kWidthForCollectionViewCell

final class HomeVC: UIViewController {
    // MARK: Outlets
    @IBOutlet private weak var mainTableView: UITableView!
    
    // MARK: Properties
    private var viewModel: HomeVM
    
    // MARK: Lifecycle
    init() {
        viewModel = HomeVM()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        bindViewModel()
    }
}

// MARK: UITableViewDataSource
extension HomeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = mainTableView
            .dequeueReusableHeaderFooterView(withIdentifier: "HomeTableHeaderView" ) as? HomeTableHeaderView
        else { return .init() }
        cell.configure(title: viewModel.sections[section].title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kNumberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTableView
            .dequeueReusableCell(
                withIdentifier: "HomeTableViewCell",
                for: indexPath
            ) as? HomeTableViewCell
        else { return .init() }
        return cell
    }
}

// MARK: UITableViewDelegate
extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kHeightForHeaderInSectionTableView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kHeightForCollectionViewCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? HomeTableViewCell else { return }
        cell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.section)
    }
}

// MARK: UICollectionViewDataSource
extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.sections[collectionView.tag].contents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: "HomeItemCell",
                for: indexPath
            ) as? HomeItemCell
        else { return .init() }
        
        let content = viewModel.sections[collectionView.tag].contents[indexPath.item]
        
        let image = content.cover?.first?.url
        ?? content.images?.first?.url
        ?? content.visuals?.avatar.first?.url
        ?? ""
        
        cell.configure(title: content.name, image: image, type: content.type)
        
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: kWidthForCollectionViewCell, height: kHeightForCollectionViewCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = TrackListVC(sectionContent: viewModel.sections[collectionView.tag].contents[indexPath.item])
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: Custom Functions
extension HomeVC {
    private func setupViews() {
        showLoading()
        mainTableView.showsVerticalScrollIndicator = false
    }
    
    private func setupListViews() {
        mainTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil),
                               forCellReuseIdentifier: "HomeTableViewCell")
        mainTableView.register(UINib(nibName: "HomeTableHeaderView", bundle: nil),
                               forHeaderFooterViewReuseIdentifier: "HomeTableHeaderView")
        mainTableView.dataSource = self
        mainTableView.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.fetchSections { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.hideLoading(after: 1)
                    self.setupListViews()
                    self.mainTableView.reloadData()
                }
            case .failure(let error):
                self.hideLoading()
                if error == .expiredKey {
                    self.showAlert(title: error.customMessage.uppercased(), message: "Please Update API Key!") {
                        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                        sleep(2)
                        exit(0)
                    }
                }
            }
        }
    }
}
