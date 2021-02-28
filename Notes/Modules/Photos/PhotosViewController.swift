//
//  PhotosViewController.swift
//  Notes
//
//  Created by Gopinath.A on 28/02/21.
//

import UIKit
import CoreData

class PhotosViewController: UIViewController {
    
    var photoID: String?
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    lazy var fetchResultsControler: NSFetchedResultsController<NoteImage> = {
        let request: NSFetchRequest<NoteImage> = NoteImage.fetchRequest()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout())
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewPhotoCell")
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isUserInteractionEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func scrollTOSpecificCell() {
        guard let id = photoID else { return }
        guard let images = fetchResultsControler.fetchedObjects else { return }
        guard let index = images.firstIndex(where: {$0.id == id}) else { return }
        collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .left, animated: false)
    }
    
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let cellWidthHeightConstant: CGFloat = UIScreen.main.bounds.width
        
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: 0,
                                           bottom: 0,
                                           right: 0)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: cellWidthHeightConstant, height: cellWidthHeightConstant)
        
        return layout
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case .right:
                let index = collectionView.indexPath(for: collectionView.visibleCells.first!)
                
                collectionView.scrollToItem(at: IndexPath(row: index!.row - 1 < 0 ? 0 : index!.row - 1, section: 0), at: .left, animated: true)
            case .down:
                self.dismiss(animated: true, completion: nil)
            case .left:
                let index = collectionView.indexPath(for: collectionView.visibleCells.first!)
                
                collectionView.scrollToItem(at: IndexPath(row: index!.row + 1 < collectionView.numberOfItems(inSection: 0) ? index!.row + 1 : index!.row, section: 0), at: .right, animated: true)
            case .up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    func setupUI() {
        setupConstraints()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
//        scrollTOSpecificCell()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        view.addSubview(collectionView)
        
        do {
            try fetchResultsControler.performFetch()
        } catch  {
            print(error)
        }
        
        
        setupUI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollTOSpecificCell()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// MARK: - Extension
extension PhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = fetchResultsControler.sections?[0].numberOfObjects else { return 0 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewPhotoCell", for: indexPath) as! PhotoCollectionViewCell
        let image = fetchResultsControler.object(at: indexPath)
        cell.photo.image = UIImage(data: image.data ?? Data())
        //        cell.setupUI(note: note)
        return cell
    }
    
}

extension PhotosViewController: NSFetchedResultsControllerDelegate{
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert{
            collectionView.insertItems(at: [newIndexPath!])
        }
    }
}
