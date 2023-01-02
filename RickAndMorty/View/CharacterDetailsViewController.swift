//
//  CharacterDetailsViewController.swift
//  RickAndMorty
//
//  Created by Denny Wongso on 2/1/23.
//

import Foundation
import UIKit

protocol CharacterDetailProtocol {
    func setup(characterDetail: CharacterDetail?)
}

class CharacterDetailsViewController: UIViewController, CharacterDetailProtocol {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var imageViewStatus: UIImageView!
    @IBOutlet weak var labelGender: UILabel!
    @IBOutlet weak var imageViewGender: UIImageView!
    @IBOutlet weak var labelSpecies: UILabel!
    @IBOutlet weak var labelCreated: UILabel!
    @IBOutlet weak var labelOrigin: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var tableViewEpisode: UITableView!
    
    var cd: CharacterDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewEpisode.dataSource = self
        tableViewEpisode.delegate = self
        tableViewEpisode.separatorStyle = .none
        tableViewEpisode.layoutMargins = UIEdgeInsets.zero
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        populateInfo()
    }
    
    func setup(characterDetail: CharacterDetail?) {
        self.cd = characterDetail
    }
    
    private func populateInfo() {
        guard let cd = cd else {
            return
        }
        labelName.text = cd.name
        labelName.font = UIFont.systemFont(ofSize: 24)
        
        labelStatus.text = "Status: " + cd.status.rawValue
        labelStatus.font = UIFont.systemFont(ofSize: 20)
        imageViewStatus.image = cd.status.getIcon() ?? UIImage()
        
        labelGender.text = "Gender: " + cd.gender.rawValue
        labelGender.font = UIFont.systemFont(ofSize: 20)
        imageViewGender.image = cd.gender.getIcon() ?? UIImage()
        
        labelSpecies.text = "Species: " + cd.species.rawValue
        labelSpecies.font = UIFont.systemFont(ofSize: 20)
        labelCreated.text = cd.created
        
        labelOrigin.text = cd.origin.name
        labelLocation.text = cd.location.name
        
        if let image = cd.image {
            imageViewPhoto.image = UIImage(data: image)
        }
        imageViewPhoto.contentMode = .scaleAspectFill
        imageViewPhoto.layer.cornerRadius = 8

        
        tableViewEpisode.reloadData()
        
    }
}

extension CharacterDetailsViewController: UITableViewDataSource, UITableViewDelegate {
//    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell") as! TableCell
//        return cell.labelName.frame.height
//    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cd?.episode.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell") as! TableCell
        cell.setup(name: cd?.episode[indexPath.row] ?? "")

        return cell
    }
    
    
}
