//
//  LocationViewController.swift
//  RickAndMorty
//
//  Created by Denny Wongso on 2/1/23.
//

import Foundation
import UIKit

class LocationViewController: UIViewController {
    
    var locationViewModel: LocationViewModelProtocol?
    
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var tableViewLocation: UITableView!
    var currentSearch: String = ""
    var timer: Timer? = nil {
        willSet {
            timer?.invalidate()
        }
    }

    var lastPullIndex: IndexPath?
    
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 25.0, bottom: 20.0, right: 25.0)
    private let itemsPerRow = 2.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldSearch.delegate = self
        tableViewLocation.delegate = self
        tableViewLocation.dataSource = self
        
        let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
        let icon = UIImage(systemName: "magnifyingglass")
        imageView.image = icon
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageContainerView.addSubview(imageView)
        textFieldSearch.leftView = imageContainerView
        textFieldSearch.leftViewMode = .always
        textFieldSearch.tintColor = .lightGray
        filterData(name: "", startIndex: 0)
    }
    
    func setup(locationViewModel: LocationViewModelProtocol) {
        self.locationViewModel = locationViewModel
        
    }
    
    private func getSize() -> Int {
        return self.locationViewModel?.data.count ?? 0
    }
    
    private func getLocation(index: Int) -> LocationModel? {
        return self.locationViewModel?.data[index]
    }
   
    
    private func filterData(name: String, startIndex: Int) {
        self.locationViewModel?.filter(name: name, success: {[weak self](success, message) in
            DispatchQueue.main.async {
                self?.tableViewLocation.reloadData()
            }
        })
    }
}

extension LocationViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.getSize()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
        if let model = getLocation(index: indexPath.section) {
            cell.setup(name: model.name, location: model.type, dimension: model.dimension)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if lastPullIndex == indexPath {
            return
        }
        if indexPath.section == self.getSize() - 1 {
            self.filterData(name: textFieldSearch.text ?? "", startIndex: self.getSize())
            lastPullIndex = indexPath
        }
    }
}

extension LocationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: false)
        return true
    }
    
    @objc func fireTimer() {
        self.filterData(name: textFieldSearch.text ?? "", startIndex: 0)
    }
}
