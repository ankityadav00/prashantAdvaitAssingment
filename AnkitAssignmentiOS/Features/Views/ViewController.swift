//
//  ViewController.swift
//  AnkitAssignmentiOS
//
//  Created by Ankit yadav on 15/04/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageCollectionView: UICollectionView!{
        didSet{
            imageCollectionView.delegate = self
            imageCollectionView.dataSource = self
        }
    }
    
    var viewModel = ImageViewModel()
    var image: ImageDataModel?
    var imageData: [ImageDataModel] = []
    var imageCache = NSCache<NSURL, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imageCollectionView.register(UINib(nibName: "imagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "imagesCollectionViewCell")
        
        fetchImageData()
    }
    
    func fetchImageData() {
        viewModel.fetchData { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching image: \(error)")
            } else if let data = result {
                self.imageData = data
                self.imageCollectionView.reloadData()
            }
        }
    }
    
}

//MARK: - CollectionView Delegates and Datasource
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagesCollectionViewCell", for: indexPath) as! imagesCollectionViewCell
        let imageDataModel = imageData[indexPath.row]
        
        let domain = imageDataModel.thumbnail.domain
        let basePath = imageDataModel.thumbnail.basePath
        let qualities = imageDataModel.thumbnail.qualities[1]
        let key = imageDataModel.thumbnail.key.rawValue
        let imageURLString = "\(domain)/\(basePath)/\(qualities)/\(key)"
        
        print(imageURLString)
        
        let imageURL = URL(string: imageURLString )
        
        // Check if image is cached
        if let cachedImage = imageCache.object(forKey: imageURL! as NSURL) {
            cell.imageView.image = cachedImage
        } else {
            // Fetch image asynchronously
            URLSession.shared.dataTask(with: imageURL!) { data, response, error in
                guard let data = data, let image = UIImage(data: data) else {
                    print("Failed to load image:", error?.localizedDescription ?? "")
                    return
                }
                
                // Cache the image
                self.imageCache.setObject(image, forKey: imageURL! as NSURL)
                
                DispatchQueue.main.async {
                    cell.imageView.image = image
                }
            }.resume()
        }
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (self.imageCollectionView.frame.width - 40) / 3
        return CGSize(width: cellWidth, height: 80)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}
