import Foundation
import UIKit

class MarkDownInputPresenter:MarkDownInputModelDelegate{
    //自分用のモデルの宣言
    let markDownInputModel: MarkDownInputModel
    
    //オリジナルのクラス型にすること
    weak var view: MarkDownInputViewController?
    
    init(view: MarkDownInputViewController) {
        self.view = view
        self.markDownInputModel = MarkDownInputModel()
        markDownInputModel.delegate = self
    }
    
    func submitButtonTapped(input:String){
        print(" submit button tapped recognized")
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
        print("did submit")
    }

    func signUpButtonTapped() {
        // Presenter → Model
//        authModel.signUp(with: email, and: password)
    }

    func loginButtonTapped() {
        //Presenter → View の操作
//        view?.toLogin()
    }
}
