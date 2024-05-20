//
//  SearchActiveVC.swift
//  Rikkeify
//
//  Created by QuocLA on 20/05/2024.
//

import UIKit

class SearchActiveVC: UIViewController {
    @IBOutlet private weak var resultTableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    // MARK: Properties
    private var viewModel: SearchActiveVM
    
    // MARK: Lifecycle
    init() {
        viewModel = SearchActiveVM()
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
}

extension SearchActiveVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = resultTableView.dequeueReusableCell(withIdentifier: "SearchActiveTableViewCell", for: indexPath) as? SearchActiveTableViewCell else { return .init() }
        
        cell.configure(searchItem: viewModel.searchResults[indexPath.row])
        return cell
    }
}

extension SearchActiveVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchItem = viewModel.searchResults[indexPath.row]
        switch searchItem.type {
        case ItemType.track.rawValue:
            self.showLoading(text: "Fetching Track")
            let playback = PlaybackPresenter.shared
            playback.tracks = [Track(id: searchItem.id, name: searchItem.title, shareUrl: "", durationMs: 0, durationText: "", trackNumber: nil, playCount: 0, artists: [], album: nil, lyrics: [], audio: [])]
            playback.playerItems = [nil]
            playback.playedIndex.removeAll()
            playback.currentTrackIndex = 0
            playback.fetchTrackMetadata(index: playback.currentTrackIndex) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    playback.playTrack(index: playback.currentTrackIndex)
                    self.hideLoading(after: 1.5)
                case .failure(let error):
                    self.hideLoading(after: 1.5)
                    self.showAlert(title: error.customMessage.capitalized, message: "")
                }
            }
        default:
            let vc = TrackListVC(sectionContent: .init(type: searchItem.type, id: searchItem.id, name: searchItem.title, visuals: nil, images: [.init(url: searchItem.image, width: nil, height: nil)]))
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SearchActiveVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(query: searchText) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.resultTableView.reloadData()
                }
            case .failure(let error):
                print("\nSearch Warning: \(error.customMessage)")
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.popViewController(animated: false)
    }
}

extension SearchActiveVC {
    private func setupViews() {
        searchBar.becomeFirstResponder()
    }
    
    private func setupListViews() {
        self.resultTableView.register(UINib(nibName: "SearchActiveTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchActiveTableViewCell")
        self.resultTableView.dataSource = self
        self.resultTableView.delegate = self
    }
    
    private func bindViewModel() {
        resultTableView.reloadData()
    }
}
