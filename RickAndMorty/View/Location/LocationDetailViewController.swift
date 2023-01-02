//
//  LocationDetailViewController.swift
//  RickAndMorty
//
//  Created by Denny Wongso on 2/1/23.
//


import Foundation
import UIKit

protocol LocationDetailProtocol {
    func setup(locationDetail: LocationDetail?)
}

class LocationDetailViewController: UIViewController, LocationDetailProtocol {
    
    @IBOutlet weak var tableViewResident: UITableView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var labelDimension: UILabel!
    @IBOutlet weak var labelCreated: UILabel!



    var ld: LocationDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewResident.dataSource = self
        tableViewResident.delegate = self
        tableViewResident.separatorStyle = .none
        tableViewResident.layoutMargins = UIEdgeInsets.zero
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        populateInfo()
    }
    
    func setup(locationDetail: LocationDetail?) {
        self.ld = locationDetail
    }
    
    private func populateInfo() {
        guard let ld = ld else {
            return
        }
        self.title = ld.name
        labelName.text = ld.name
        
        labelType.text = "Type: " + ld.type
        labelCreated.text = ld.created
        labelDimension.text = ld.dimension
        tableViewResident.reloadData()
        
    }
}

extension LocationDetailViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ld?.residents.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell") as! TableCell
        cell.setup(name: ld?.residents[indexPath.row] ?? "")

        return cell
    }
}
