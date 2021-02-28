//
//  NoteDetailViewController.swift
//  Notes
//
//  Created by Gopinath.A on 28/02/21.
//

import UIKit

class NoteDetailViewController: UIViewController {
    
    var note: Note? = nil
    let viewModel: NoteDetailViewModel = NoteDetailViewModelImpl()
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    lazy var closeButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.getColor(hex: "#4b4b4b")
        button.tintColor = .white
        button.setImage(UIImage(named: "LeftArrow"), for: .normal)
        button.imageView?.contentMode = .center
        button.clipsToBounds = false
        button.addTarget(self, action: #selector(fabTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var activityImdicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(frame: .zero)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.color = UIColor.white
        ai.style = .medium
        ai.hidesWhenStopped = true
        ai.startAnimating()
        return ai
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = false
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "background")
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    
    lazy var titleLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        label.textColor = UIColor.white
        label.numberOfLines = 0
        return label
    }()
    
    lazy var dateLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 0
        return label
    }()
    
    lazy var bodyTextView:UITextView = {
        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 21, weight: .regular)
        textView.textColor = UIColor.white
        textView.isScrollEnabled = true
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.linkTextAttributes = [
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .font : UIFont.systemFont(ofSize: 21, weight: .regular)
        ]
        return textView
    }()
    
    let stackView: UIStackView = {
       let view = UIStackView()
        view.alignment = .fill
        view.distribution = .fill
        view.axis = .vertical
        view.spacing = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Functions
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let vc = PhotosViewController()
        vc.photoID = self.note!.id
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(vc, animated: true, completion: nil)
      }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.heightAnchor.constraint(equalToConstant: 48),
            closeButton.widthAnchor.constraint(equalToConstant: 48),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 220),
            
            activityImdicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            activityImdicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            bodyTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            bodyTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            bodyTextView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc func fabTapped(_ button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateView() {
        guard let data = note else { return }
        titleLabel.text = data.title
        dateLabel.text = data.time!.getDate()
        bodyTextView.attributedText = viewModel.getUpdatedBodyText()
        
        if let image = data.imageData{
            guard let img = image.data else {
                imageView.isHidden = true
                return
            }
            let loadedImage = UIImage(data: img)
            imageView.image = loadedImage
            activityImdicator.stopAnimating()
        }else if data.image?.isEmpty ?? true{
            imageView.isHidden = true
        }else{
            viewModel.downloadImage { image in
                DispatchQueue.main.async { [self] in
                    guard let img = image else{ return }
                    imageView.image = img
                    activityImdicator.stopAnimating()
                }
            }
        }
        
        
    }
    
    func setupUI() {
        self.view.addSubview(closeButton)
        imageView.addSubview(activityImdicator)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(bodyTextView)
        self.view.addSubview(stackView)
        
        guard let data = self.note else { return }
        viewModel.updateNoteDetail(with: data)
        
        setupConstraints()
        
        closeButton.layer.cornerRadius = 10
        
//        imageView.hero.id = "skyWalker"
        
        
        if let patternImage = UIImage(named: "background") {
            view.backgroundColor = UIColor(patternImage: patternImage)
        }
        updateView()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
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
