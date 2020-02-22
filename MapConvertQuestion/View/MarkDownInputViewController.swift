import UIKit

class MarkDownInputViewController: UIViewController,MarkDownInputViewDelegate{
    
    var presenter:MarkDownInputPresenter!
    override func viewDidLoad(){
        super.viewDidLoad()
        initializePresenter()
        layout()
    }
    
    func layout(){
        let customView = MarkDownInput(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
        customView.myDelegate = self
        self.view.addSubview(customView)
    }
    
    func initializePresenter() {
       presenter = MarkDownInputPresenter(view: self)
    }
    // Presenter ← View
    func signUpButtonTapped() {
    }
    
    func submitAction(text:String) {
        var lines = [String]()
        text.enumerateLines { (line, stop) -> () in
            lines.append(line)
        }
        print("lines")
        print("\(lines)")
        presenter.submitButtonTapped(input: text)
    }
    
//    func convertToNode(parent_){
        
//    }
    
}

protocol MarkDownInputViewDelegate {
    func submitAction(text:String) -> Void
}
