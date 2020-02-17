import UIKit

class MarkDownInputViewController: UIViewController,MarkDownInputViewDelegate{
    
    var presenter:MarkDownInputPresenter!
    override func viewDidLoad(){
        super.viewDidLoad()
        initializePresenter()
        let customView = MarkDownInput(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        customView.myDelegate = self
        view.addSubview(customView)
    }
    
    func initializePresenter() {
       presenter = MarkDownInputPresenter(view: self)
    }
    // Presenter ← View
    func signUpButtonTapped() {
    }
    
    func submitAction(text:String) {
        print("text")
        print("\(text)")
    }
    
}

protocol MarkDownInputViewDelegate {
    func submitAction(text:String) -> Void
}
