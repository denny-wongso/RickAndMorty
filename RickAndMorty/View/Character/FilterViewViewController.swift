//
//  FilterViewViewController.swift
//  RickAndMorty
//
//  Created by Denny Wongso on 1/1/23.
//

import Foundation
import UIKit

protocol FilterViewDelegate: AnyObject {
    func filterSelected(status: String, species: String, gender: String)
}

class FilterViewViewController: UIViewController {
    @IBOutlet weak var collectionViewStatus: UICollectionView!
    @IBOutlet weak var collectionViewSpecies: UICollectionView!
    @IBOutlet weak var collectionViewGender: UICollectionView!
    
    var characterFilterViewModel: CharacterFilterViewModelProtocol?
    weak var delegate: FilterViewDelegate?
    var status: String = ""
    var species: String = ""
    var gender: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewStatus.dataSource = self
        collectionViewSpecies.dataSource = self
        collectionViewGender.dataSource = self
        collectionViewStatus.delegate = self
        collectionViewSpecies.delegate = self
        collectionViewGender.delegate = self
        roundViews()
        
        let layout1 = UICollectionViewFlowLayout()
        layout1.minimumInteritemSpacing = 5
        layout1.minimumLineSpacing = 5
        layout1.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let layout2 = UICollectionViewFlowLayout()
        layout2.minimumInteritemSpacing = 5
        layout2.minimumLineSpacing = 5
        layout2.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let layout3 = UICollectionViewFlowLayout()
        layout3.minimumInteritemSpacing = 5
        layout3.minimumLineSpacing = 5
        layout3.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.collectionViewStatus.collectionViewLayout = layout1
        self.collectionViewSpecies.collectionViewLayout = layout2
        self.collectionViewGender.collectionViewLayout = layout3
    }
    
    override func viewWillAppear(_ animated: Bool) {
        status = ""
        gender = ""
        species = ""
        collectionViewStatus.reloadData()
        collectionViewSpecies.reloadData()
        collectionViewGender.reloadData()
    }
    func roundViews() {
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
    }
    
    func setup(characterFilterViewModelProtocol: CharacterFilterViewModelProtocol) {
        self.characterFilterViewModel = characterFilterViewModelProtocol
    }
    
    private func nonSelectedColor() -> CGColor {
        return CGColor(red: 190/255.0, green: 190/255.0, blue: 190/255.0, alpha: 1)
    }
    private func selectedColor() -> CGColor {
        return CGColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1)
    }
   
    
    @IBAction func buttonFilterClick(_ sender: Any) {
        delegate?.filterSelected(status: status, species: species, gender: gender)
        self.dismiss(animated: true)
    }
}

extension FilterViewViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewStatus {
            return characterFilterViewModel?.getStatus().count ?? 0
        } else if collectionView == collectionViewGender {
            return characterFilterViewModel?.getGender().count ?? 0
        } else {
            return characterFilterViewModel?.getSpecies().count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell1", for: indexPath) as! FilterCell
        var data = ""
        var selected = false
        if collectionView == collectionViewStatus {
            data = characterFilterViewModel?.getStatus()[indexPath.row] ?? ""
            selected = data == status
        } else if collectionView == collectionViewGender {
            data = characterFilterViewModel?.getGender()[indexPath.row] ?? ""
            selected = data == gender
        } else {
            data = characterFilterViewModel?.getSpecies()[indexPath.row] ?? ""
            selected = data == species
        }
        cell.labelCell.text = data
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 8
        cell.layer.borderWidth = 2
        cell.layer.borderColor = selected ? selectedColor() : nonSelectedColor()
        cell.labelCell.textColor = UIColor(cgColor: selected ? selectedColor() : nonSelectedColor())
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewStatus {
            status = characterFilterViewModel?.getStatus()[indexPath.row] ?? ""
        } else if collectionView == collectionViewGender {
            gender = characterFilterViewModel?.getGender()[indexPath.row] ?? ""
        } else {
            species = characterFilterViewModel?.getSpecies()[indexPath.row] ?? ""
        }
        collectionView.reloadData()
    }

}
