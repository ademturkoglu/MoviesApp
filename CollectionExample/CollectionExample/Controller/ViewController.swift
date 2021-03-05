//
//  ViewController.swift
//  CollectionExample
//
//  Created by Appinventiv on 27/02/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
    private var list = false
    var items = ["AAAAAAAA","BBBBBBBBBBBBBBBBB","CCCCC","D","E","F","G","H","I"]
    let itemNo = 2
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func changeLayout(_ Sender: UIButton){
        self.list = !self.list
        
        if list{
            Sender.setImage(UIImage(named: "grid"), for: .normal)
        }
        else{
            Sender.setImage(UIImage(named: "list"), for: .normal)
        }
        self.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if !list{
            let collCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath ) as! CollectionCell
            collCell.titleLabel.text = items[indexPath.item]

            collCell.imageView.image = UIImage(named: items[indexPath.item])
            return collCell
        }
        else{
            let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath ) as! ListCell
            listCell.imageView.image = UIImage(named: items[indexPath.item])
            listCell.titleLabel.text = items[indexPath.item]
            return listCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        if list{
            return  CGSize(width: width, height: 120)
        }else{
            let paddingSpace = (itemNo+1) * 5
            let availableWidth = self.view.frame.size.width - CGFloat(paddingSpace)
            let width = availableWidth/CGFloat(itemNo)
            return CGSize(width: width, height: width)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath as IndexPath, animated: false)
    }
    
    
}



