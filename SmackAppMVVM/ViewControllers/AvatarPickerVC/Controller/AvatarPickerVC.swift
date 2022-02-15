//
//  AvatarPickerVC.swift
//  SmackAppMVVM
//
//  Created by Bisma Soomro on 31/01/2022.
//

import UIKit

class AvatarPickerVC: UIViewController {
    let viewModel = AvatarPickerViewModel()
    
    // outlets
    @IBOutlet weak var avatarCollectionView: UICollectionView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setViewController(view: self)
        viewModel.setupCollectionView()
    }
    
    // MARK: - backBtnPressed(_ sender: Any)
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - segmentPressed(_ sender: Any)
    @IBAction func segmentPressed(_ sender: Any) {
        viewModel.segmentSelection()
    }
}
