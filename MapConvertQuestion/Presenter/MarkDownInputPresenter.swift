import Foundation
import UIKit

class MarkDownInputPresenter{
    //自分用のモデルの宣言
//    let authModel: AuthModel
    
    //オリジナルのクラス型にすること
    weak var view: MarkDownInputViewController?
    
    init(view: MarkDownInputViewController) {
        self.view = view
        //modelの代入
//        self.authModel = AuthModel()
//        modelのdelegate = self
//        authModel.delegate = self
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
