//
//  AvatarPickerViewModel.swift
//  SmackAppMVVM
//
//  Created by Bisma Soomro on 02/02/2022.
//

import Foundation

class AvatarPickerViewModel: NSObject{
    
    var viewController: AvatarPickerVC?
    var avatarType = AvatarType.dark
    
    //MARK: - setViewController()
    func setViewController(view: AvatarPickerVC) {
        self.viewController = view
    }
    
    //MARK: - setupCollectionView()
    func setupCollectionView(){
        self.viewController?.avatarCollectionView.delegate = self
        self.viewController?.avatarCollectionView.dataSource = self
    }
    
    //MARK: - segmentSelection()
    func segmentSelection(){
        if self.viewController?.segmentControl.selectedSegmentIndex == 0 {
            avatarType = .dark
        }
        else{
            avatarType = .light
        }
        self.viewController?.avatarCollectionView.reloadData()
    }
}

extension AvatarPickerViewModel: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - NumOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    //MARK: - cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as? AvatarCell{
            cell.viewModel.setItemData(index: indexPath.item, type: avatarType)
            return cell
        }
        return AvatarCell()
    }
    
    //MARK: - numberOfSections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //MARK: - didSelectItem
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if avatarType == .dark {
            UserDataService.instance.setupAvatarName(avatarName: "dark\(indexPath.item)")
        }
        else{
            UserDataService.instance.setupAvatarName(avatarName: "light\(indexPath.item)")
        }
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var numOfColoums: CGFloat = 4
        if UIScreen.main.bounds.width > 520{
            numOfColoums = 5
        }
        let spaceBetweenCells: CGFloat = 10
        let padding : CGFloat = 40
        let cellDimension = ((viewController!.avatarCollectionView.bounds.width - padding) - (numOfColoums - 1) * spaceBetweenCells) / numOfColoums
        return CGSize(width: cellDimension, height: cellDimension)
    }
}
