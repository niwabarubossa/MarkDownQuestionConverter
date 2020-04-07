import Foundation
import UIKit

class MarkDownInputPresenter:MarkDownInputModelDelegate{

    let markDownInputModel: MarkDownInputModel
    weak var view: MarkDownInputViewController?
    
    init(view: MarkDownInputViewController) {
        self.view = view
        self.markDownInputModel = MarkDownInputModel()
        markDownInputModel.delegate = self
    }
    
    func submitButtonTapped(input:String){
        markDownInputModel.submitInput(input:input)
        self.view?.customView.inputTextView.text = ""
        self.submitButtonEnabled()
    }
    
    func submitButtonDisabled(){
        self.view?.customView.submitButton.isEnabled = false
        self.view?.customView.submitButton.alpha = 0.5
    }
    
    private func submitButtonEnabled(){
        self.view?.customView.submitButton.isEnabled = true
        self.view?.customView.submitButton.alpha = 1
    }

    
    func didSubmitInput(){
    }

    func signUpButtonTapped() {
    }

    func loginButtonTapped() {
    }
}
