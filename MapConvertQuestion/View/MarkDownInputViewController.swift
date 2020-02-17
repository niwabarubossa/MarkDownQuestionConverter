import UIKit

class MarkDownInputViewController: UIViewController{

    var presenter:MarkDownInputPresenter!
    override func viewDidLoad(){
        super.viewDidLoad()
        initializePresenter()
    }
    
    func initializePresenter() {
       presenter = MarkDownInputPresenter(view: self)
    }
    // Presenter ← View
    func signUpButtonTapped() {
    }

}
