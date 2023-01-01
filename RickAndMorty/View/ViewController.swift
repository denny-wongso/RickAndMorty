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
    
    @IBOutlet weak var collectionViewCharacters: UICollectionView!
    @IBOutlet weak var textFieldSearch: UITextField!

    
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 25.0, bottom: 20.0, right: 25.0)
    private let itemsPerRow = 2.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewCharacters.dataSource = self
        collectionViewCharacters.delegate = self
        
        let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
        let icon = UIImage(systemName: "magnifyingglass")
        imageView.image = icon
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageContainerView.addSubview(imageView)
        textFieldSearch.leftView = imageContainerView
        textFieldSearch.leftViewMode = .always
        textFieldSearch.tintColor = .lightGray
        loadMoreData(initial: true)
    }
    
    func setup(characterViewModel: CharacterViewModelProtocol, filterViewController: UIViewController) {
        self.characterViewModel = characterViewModel
        self.filterViewController = filterViewController
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

    
    func loadMoreData(initial: Bool) {
        // Make a request to your backend to fetch the additional data
        let startIndex = self.getSize()
        if initial {
            self.characterViewModel?.getCharacters(success: { [startIndex, weak self] (success, message) in
                if success {
                    self?.appendCollectionView(startIndex: startIndex)
                }
            })
        } else {
            self.characterViewModel?.getNextPaginationCharacters(success: { [startIndex, weak self] (success, message) in
                if success {
                    self?.appendCollectionView(startIndex: startIndex)
                }
            })
        }
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
            self.getImageData(path: model.image, data: {(data) in
                DispatchQueue.main.async {
                    cell.addImage(image: data)
                }
            })
            
        }
        return cell
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == self.getSize() - 1 {
            // The last cell is about to be displayed, so load more data
            loadMoreData(initial: false)
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

    }
}
