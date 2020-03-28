//
//  OpinionFormViewController.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/03/28.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit
import FirebaseFirestore

class OpinionFormViewController: UIViewController,SubmitFirestoreDocProtocol{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myTextView.delegate = self
        layout()
    }
    
    private func layout(){
        self.titleLabel.text = "opinionLabel".localized
        self.submitButton.setTitle("submitOpiniton".localized, for: .normal)
        let font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(400))
        self.submitButton.titleLabel?.font = font
        submitButton.setTitleColor(UIColor.white, for: .normal)
    }
    @IBAction func submitButtonTapped(_ sender: Any) {
         let db = Firestore.firestore()
        let opinionDocRef = db.collection("opinion").document()
        let document_id = opinionDocRef.documentID
        let refArray = [opinionDocRef]
        let submit_data = [
            "id": document_id,
            "text": myTextView.text!,
            "created_at": Date(),
            ] as [String : Any]
        self.submitFirestoreDocument(ref_array: refArray, submit_data: submit_data)
    }
}

extension OpinionFormViewController:UITextViewDelegate{
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
      self.view.endEditing(true)
      return true
    }
}
