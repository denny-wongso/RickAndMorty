//
//  EpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Denny Wongso on 3/1/23.
//

import Foundation
import UIKit

protocol EpisodeDetailProtocol {
    func setup(episodeDetail: EpisodeDetail?)
}

class EpisodeDetailViewController: UIViewController, EpisodeDetailProtocol {
    
    @IBOutlet weak var tableViewCharacters: UITableView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAirdate: UILabel!
    @IBOutlet weak var labelSeason: UILabel!
    @IBOutlet weak var labelEpisode: UILabel!
    @IBOutlet weak var labelCreated: UILabel!



    var ed: EpisodeDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewCharacters.dataSource = self
        tableViewCharacters.delegate = self
        tableViewCharacters.separatorStyle = .none
        tableViewCharacters.layoutMargins = UIEdgeInsets.zero
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        populateInfo()
    }
    
    func setup(episodeDetail: EpisodeDetail?) {
        self.ed = episodeDetail
    }
    
    private func populateInfo() {
        guard let ed = ed else {
            return
        }
        self.title = ed.name
        labelName.text = ed.name
        
        labelAirdate.text = "Air Date: " + ed.air_date
        labelSeason.text = "Season: " + String(ed.season)
        labelEpisode.text = "Episode: " + String(ed.episode)
        labelCreated.text = ed.created
        tableViewCharacters.reloadData()
        
    }
}

extension EpisodeDetailViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ed?.characters.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell") as! TableCell
        cell.setup(name: ed?.characters[indexPath.row] ?? "")

        return cell
    }
}
