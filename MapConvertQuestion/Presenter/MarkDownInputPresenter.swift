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
