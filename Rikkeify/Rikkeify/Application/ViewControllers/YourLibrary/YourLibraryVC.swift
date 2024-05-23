//
//  YourLibraryVC.swift
//  Rikkeify
//
//  Created by QuocLA on 20/05/2024.
//

import UIKit

class YourLibraryVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onLikedSongsPicked(_ sender: Any) {
        let vc = TrackListVC(sectionContent: SectionContent(type: "liked", id: "likedlist", name: "Liked Songs", visuals: nil, images: nil))
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onDownloadedSongsPicked(_ sender: Any) {
        let vc = TrackListVC(sectionContent: SectionContent(type: "downloaded", id: "downloadedlist", name: "Downloaded Songs", visuals: nil, images: nil))
        navigationController?.pushViewController(vc, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
