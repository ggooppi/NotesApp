//
//  ViewController.swift
//  Notes
//
//  Created by Gopinath.A on 26/02/21.
//

import UIKit
import CoreData

class NoteListViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel: NoteListViewModel = NoteListViewModelImpl()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: NotesLayout())
        collectionView.register(NoteCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isUserInteractionEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var notesLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Notes"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        return label
    }()
    
    lazy var fabButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.tintColor = .white
        button.setImage(UIImage(named: "Add"), for: .normal)
        button.imageView?.contentMode = .center
        button.clipsToBounds = false
        button.addTarget(self, action: #selector(fabTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.tintColor = .white
        button.setImage(UIImage(named: "Add"), for: .normal)
        button.imageView?.contentMode = .center
        button.clipsToBounds = false
        button.addTarget(self, action: #selector(fabTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var fetchResultsControler: NSFetchedResultsController<Note> = {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "time", ascending: false)]
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    
    // MARK: - Actions
    @objc func fabTapped(_ button: UIButton) {
        let vc = CreateNoteViewController()
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let layout = collectionView.collectionViewLayout as? NotesLayout {
          layout.delegate = self
        }
        
        do {
            try fetchResultsControler.performFetch()
        } catch  {
            print(error)
        }
        
        setupUI()
        viewModel.getNotes {[weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.layoutIfNeeded()
        collectionView.layoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let view = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            view.addSubview(fabButton)
            setupButton()
        }
    }
    
    // MARK: - Constraints
    private func setupButton() {
        NSLayoutConstraint.activate([
            fabButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            fabButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            fabButton.heightAnchor.constraint(equalToConstant: 56),
            fabButton.widthAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: notesLabel.bottomAnchor, constant: 8),
            collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            notesLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            notesLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
        ])

    }
    
    
    // MARK: - Setup UI
    private func setupUI() {
        self.view.addSubview(collectionView)
        self.view.addSubview(notesLabel)
        collectionView.backgroundColor = .clear
        fabButton.layer.cornerRadius = 56 / 2
        if let patternImage = UIImage(named: "background") {
            view.backgroundColor = UIColor(patternImage: patternImage)
        }
        setupConstraints()
    }
    
    
}


// MARK: - Extension
extension NoteListViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = fetchResultsControler.sections?[0].numberOfObjects else { return 0 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! NoteCollectionViewCell
        let note = fetchResultsControler.object(at: indexPath)
        cell.setupUI(note: note)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let note = fetchResultsControler.object(at: indexPath)
        let vc = NoteDetailViewController()
        vc.note = note
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(vc, animated: true, completion: nil)
//        self.performSegue(withIdentifier: "goDetail", sender: note)
    }
    
}

extension NoteListViewController: NotesLayoutDelegate {
  func collectionView(
      _ collectionView: UICollectionView,
      heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
    
    var width: CGFloat = 0
    var attributes:[NSAttributedString.Key: UIFont] = [:]
    let attributes2: [NSAttributedString.Key: UIFont] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular)]
    
    let note = fetchResultsControler.object(at: indexPath)
    
    if note.image != nil{
        width = collectionView.frame.width - 20
        attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold)]
    }else{
        width = (collectionView.frame.width / 2) - 20
        attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold)]
    }
    let size = CGSize(width: width, height: 10000)
    
    let estimatedFrame = NSString(string: note.title ?? "").boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
    let estimatedDateFrame = NSString(string: note.time ?? "").boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes2, context: nil)
    
    return estimatedFrame.height + estimatedDateFrame.height + 40
  }
    
    func collectionView(_ collectionView: UICollectionView, hasImageURL indexPath: IndexPath) -> Bool {
        if indexPath.row < 0{
            return false
        }
        let note = fetchResultsControler.object(at: indexPath)
        return note.image != nil ? true : false
    }
}

extension NoteListViewController: NSFetchedResultsControllerDelegate{
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert{
            collectionView.insertItems(at: [newIndexPath!])
        }
    }
}



 
