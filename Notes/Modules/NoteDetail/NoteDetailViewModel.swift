//
//  NoteDetailViewModel.swift
//  Notes
//
//  Created by Gopinath.A on 28/02/21.
//

import Foundation
import UIKit

protocol NoteDetailViewModel {
    func updateNoteDetail(with note: Note)
    func getUpdatedBodyText() -> NSAttributedString
    func downloadImage(completion: @escaping (UIImage?) -> Void)
}

class NoteDetailViewModelImpl: NoteDetailViewModel {
    
    private var note: Note? = nil
    private let respository: NoteDetailRepository
    
    init(repository: NoteDetailRepository = NoteDetailRepositoryImpl()) {
        self.respository = repository
    }
    
    func updateNoteDetail(with note: Note) {
        self.note = note
    }
    
    func getUpdatedBodyText() -> NSAttributedString {
        return makeTextHyperLink()
    }
    
    func downloadImage(completion: @escaping (UIImage?) -> Void) {
        if let imageURL = self.note!.image{
            if self.note!.imageData == nil{
                respository.downloadImage(id: self.note!.id!, imageURL: imageURL) { image in
                    completion(image)
                } error: { (err) in
                    print(err)
                    completion(nil)
                }
                
            }
        }
    }
    
    private func makeTextHyperLink() -> NSAttributedString {
        guard let nodeData = self.note else { return NSAttributedString(string: "") }
        let identifiedTextMatches = nodeData.body!.matches(for: "\\[.*\\]",dropNumber: 1)
        let identiedMatches = nodeData.body!.matches(for: "\\*\\*(.*?)\\*\\*",dropNumber: 2)
        let identifiedURLMatches = nodeData.body!.getURLs()
        
        var updateString = nodeData.body!
        
        for item in 0..<identifiedTextMatches.count {
            updateString = updateString.replacingOccurrences(of: "[\(identifiedTextMatches[item])](", with: "")
        }
        
        updateString = updateString.replacingOccurrences(of: ")", with: "")
        updateString = updateString.replacingOccurrences(of: "**", with: "")
        
        var attributedString = NSAttributedString(string: updateString, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 21), NSAttributedString.Key.foregroundColor: UIColor.white])
        
        for item in 0..<identifiedTextMatches.count {
            attributedString =  attributedURLText(withString: attributedString.string,
                                                  url: identifiedURLMatches[item],
                                                  valueURL: identifiedTextMatches[item],
                                                  valueBold: item < identiedMatches.count ? identiedMatches[item]: "" ,
                                                  font: UIFont.systemFont(ofSize: 21))
        }
       
        return attributedString
        
        
    }
    
    private func attributedURLText(withString string: String, url: String, valueURL: String, valueBold: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.white])
        
        let range = (string as NSString).range(of: url)
        attributedString.replaceCharacters(in: range, with: valueURL)
        let rangeForURL = (attributedString.string as NSString).range(of: valueURL)
        attributedString.setAttributes([.link: url, .font: font], range: rangeForURL)
        
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .bold)]
        let rangeBold = (attributedString.string as NSString).range(of: valueBold)
        attributedString.addAttributes(boldFontAttribute, range: rangeBold)
        
        
        return attributedString
    }
    
    
}
