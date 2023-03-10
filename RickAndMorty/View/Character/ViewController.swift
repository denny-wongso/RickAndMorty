//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Denny Wongso on 30/12/22.
//

import UIKit

class ViewController: UIViewController {
    
    var characterViewModel: CharacterViewModelProtocol?
    var filterViewController: UIViewController?
    var detailViewController: CharacterDetailProtocol?
    
    @IBOutlet weak var collectionViewCharacters: UICollectionView!
    @IBOutlet weak var textFieldSearch: UITextField!
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
        collectionViewCharacters.dataSource = self
        collectionViewCharacters.delegate = self
        textFieldSearch.delegate = self
        
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
    
    func setup(characterViewModel: CharacterViewModelProtocol, filterViewController: UIViewController, characterDetailViewController: CharacterDetailProtocol) {
        self.characterViewModel = characterViewModel
        self.filterViewController = filterViewController
        self.detailViewController = characterDetailViewController
        let doneButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(filterButtonTapped))
        doneButton.image = UIImage(systemName: "slider.horizontal.3")
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func filterButtonTapped() {
        guard let vc = filterViewController else {
            return
        }
        vc.modalPresentationStyle = .pageSheet
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        present(vc, animated: true, completion: nil)
    }
    
    private func appendCollectionView(startIndex: Int) {
        let endIndex = self.getSize() - 1
        let indexPaths = (startIndex...endIndex).map { IndexPath(item: $0, section: 0) }
        DispatchQueue.main.async { [weak self] in
            self?.collectionViewCharacters.insertItems(at: indexPaths)
        }
    }
    
    private func getSize() -> Int {
        return self.characterViewModel?.data.count ?? 0
    }
    
    private func getCharacter(index: Int) -> CharacterModel? {
        return self.characterViewModel?.data[index]
    }
    
    private func getImageData(path: String, data: @escaping (Data) -> Void)  {
        self.characterViewModel?.getImage(path: path, data: {[data](image) in
            if let image = image {
                data(image)
            }
        })
    }
    
    private func filterData(name: String, startIndex: Int) {
        self.characterViewModel?.filter(name: name, success: {[weak self](success, message) in
            if startIndex == 0 || !success {
                DispatchQueue.main.async {
                    self?.collectionViewCharacters.reloadData()
                }
                return
            }
            self?.appendCollectionView(startIndex: startIndex)
        })
    }
    
    private func filterData(status: String, species: String, gender: String) {
        self.characterViewModel?.filter(status: status, species: species, gender: gender, success: {[weak self](success, message) in
                DispatchQueue.main.async {
                    self?.collectionViewCharacters.reloadData()
                }
        })
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: false)
        return true
    }
    
    @objc func fireTimer() {
        self.filterData(name: textFieldSearch.text ?? "", startIndex: 0)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.getSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Character", for: indexPath) as! CharacterCell
        
        if let model = self.getCharacter(index: indexPath.row) {
            DispatchQueue.main.async {
                cell.setup(name: model.name, place: model.species)
            }
            self.getImageData(path: model.image, data: {[weak self](data) in
                self?.characterViewModel?.data[indexPath.row].addImageData(imageData: data)
                DispatchQueue.main.async {
                    cell.addImage(image: data)
                }
            })
            
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if lastPullIndex == indexPath {
            return
        }
        if indexPath.item == self.getSize() - 1 {
            // The last cell is about to be displayed, so load more data
            self.filterData(name: textFieldSearch.text ?? "", startIndex: self.getSize())
            lastPullIndex = indexPath
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = characterViewModel?.data[indexPath.row].imageData
        
        guard let id = characterViewModel?.data[indexPath.row].id else {
            return
        }
        
        guard let cd = characterViewModel?.getCharacterDetail(id: id, image: image) else {
            return
        }
        detailViewController?.setup(characterDetail: cd)
        if let vc = detailViewController as? UIViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      // 2
      let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
      let availableWidth = collectionView.frame.width - paddingSpace
      let widthPerItem = availableWidth / itemsPerRow
      
      return CGSize(width: round(widthPerItem), height: round(widthPerItem) + 57)
        
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension ViewController: FilterViewDelegate {
    func filterSelected(status: String, species: String, gender: String) {
        self.filterData(status: status, species: species, gender: gender)
    }
}
