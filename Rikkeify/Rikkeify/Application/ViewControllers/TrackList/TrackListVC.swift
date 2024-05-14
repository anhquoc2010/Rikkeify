//
//  TrackList.swift
//  Rikkeify
//
//  Created by PearUK on 14/5/24.
//

import UIKit

class TrackListVC: UIViewController {
    
    private var viewModel: TrackListVM
    
    @IBOutlet weak var nameTableView: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var tracksTableView: IntrinsicTableView!
    
    // MARK: Lifecycle
    init(sectionContent: SectionContent) {
        viewModel = TrackListVM(sectionContent: sectionContent)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.thumbImageView.setNetworkImage(urlString: self.viewModel.thumbImage)
        self.nameTableView.text = self.viewModel.titleName
        
        viewModel.fetchSectionContent { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.tracksTableView.register(UINib(nibName: "TrackListTableViewCell", bundle: nil), forCellReuseIdentifier: "TrackListTableViewCell")
                    self.tracksTableView.dataSource = self
                    self.tracksTableView.delegate = self
                    
                    self.tracksTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    @IBAction func onBackButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onPlayButtonTapped(_ sender: UIButton) {
        present(TrackViewVC(tracks: viewModel.tracks), animated: true)
    }
}

extension TrackListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tracksTableView
            .dequeueReusableCell(
                withIdentifier: "TrackListTableViewCell",
                for: indexPath
            ) as? TrackListTableViewCell
        else { return .init() }
        
        cell.configure(track: viewModel.tracks[indexPath.row], thumbImage: viewModel.thumbImage)
        
        return cell
    }
}

extension TrackListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
}
