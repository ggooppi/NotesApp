//
//  CreateNoteViewController.swift
//  Notes
//
//  Created by Gopinath.A on 28/02/21.
//

import UIKit

class CreateNoteViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Properties
    var imagePicker = UIImagePickerController()
    let viewModel: CreateNoteViewModel = CreateNoteViewModelImpl()
    
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
    
    lazy var attachButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.getColor(hex: "#4b4b4b")
        button.tintColor = .white
        button.setImage(UIImage(named: "Attach"), for: .normal)
        button.imageView?.contentMode = .center
        button.clipsToBounds = false
        button.addTarget(self, action: #selector(attachTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.getColor(hex: "#4b4b4b")
        button.tintColor = .white
        button.setTitle("Save", for: .normal)
        button.clipsToBounds = false
        button.addTarget(self, action: #selector(saveTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var titleTextField:UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        textField.attributedPlaceholder = NSAttributedString(string: "Title",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 32, weight: .semibold)])
        textField.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        textField.textColor = UIColor.white
        textField.delegate = self
        return textField
    }()
    
    lazy var bodyTextView:UITextView = {
        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 21, weight: .regular)
        textView.text = "Type something..."
        textView.textColor = UIColor.lightGray
        textView.isScrollEnabled = true
        textView.isUserInteractionEnabled = true
        textView.delegate = self
        return textView
    }()
    
    
    // MARK: - Actions
    @objc func fabTapped(_ button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func attachTapped(_ button: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func saveTapped(_ button: UIButton) {
        if titleTextField.text?.isEmpty ?? true || bodyTextView.textColor == UIColor.lightGray{
            showAlert(withTitle: "Error", withMessage: "Title and Body both are required")
        }else{
            viewModel.saveNote(title: titleTextField.text!, body: bodyTextView.text) {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
                
            }
        }
    }
    
    @objc func onKeyboardAppear(_ notification: NSNotification) {
        let info = notification.userInfo
        if let keyboardRect = info?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect {
            
            let keyboardSize = keyboardRect.size
            bodyTextView.contentInset = UIEdgeInsets(top: 0, left: 0,
                                                     bottom: keyboardSize.height, right: 0)
            bodyTextView.scrollIndicatorInsets = bodyTextView.contentInset
        }
    }
    
    @objc func onKeyboardDisappear(_ notification: NSNotification) {
        bodyTextView.contentInset = UIEdgeInsets(top: 0, left: 0,
                                                 bottom: 0, right: 0)
        bodyTextView.scrollIndicatorInsets = bodyTextView.contentInset
    }
    
    // MARK: - Functions
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.heightAnchor.constraint(equalToConstant: 48),
            closeButton.widthAnchor.constraint(equalToConstant: 48)
        ])
        
        NSLayoutConstraint.activate([
            attachButton.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -8),
            attachButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            attachButton.heightAnchor.constraint(equalToConstant: 48),
            attachButton.widthAnchor.constraint(equalToConstant: 48)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            saveButton.heightAnchor.constraint(equalToConstant: 48),
            saveButton.widthAnchor.constraint(equalToConstant: 68)
        ])
        
        NSLayoutConstraint.activate([
            titleTextField.leadingAnchor.constraint(equalTo: closeButton.leadingAnchor),
            titleTextField.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            bodyTextView.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor, constant: 2),
            bodyTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
            bodyTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 16),
            bodyTextView.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
        ])
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupUI() {
        if let patternImage = UIImage(named: "background") {
            view.backgroundColor = UIColor(patternImage: patternImage)
        }
        
        self.view.addSubview(closeButton)
        self.view.addSubview(attachButton)
        self.view.addSubview(saveButton)
        self.view.addSubview(titleTextField)
        self.view.addSubview(bodyTextView)
        
        closeButton.layer.cornerRadius = 10
        attachButton.layer.cornerRadius = 10
        saveButton.layer.cornerRadius = 10
        titleTextField.layer.cornerRadius = 10
        
        setupConstraints()
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForKeyboardNotifications()
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

// MARK: - Extension
extension CreateNoteViewController: UITextFieldDelegate, UITextViewDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Type something..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

extension CreateNoteViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        attachButton.tintColor = .systemBlue
        
        viewModel.saveImage(imageData: image.jpegData(compressionQuality: 0.5)!)
    }
}
