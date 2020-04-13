import UIKit
import RealmSwift

class MarkDownInputViewController: UIViewController,MarkDownInputViewDelegate{
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var customView: MarkDownInput!
    @IBOutlet weak var opinionFormButton: OpinionFormButton!
    var presenter:MarkDownInputPresenter!
    var completeLabel = UILabel()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        initializePresenter()
        layout()
    }
    
    private func initializePresenter() {
       presenter = MarkDownInputPresenter(view: self)
    }
    
    func layout() {
        customView.myDelegate = self
        completeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 30, height: 100))
        completeLabel.backgroundColor = MyColor.fourthColor
        completeLabel.center = self.view.center
        completeLabel.textAlignment = .center
        completeLabel.text = "complete!!!!!!"
        self.view.addSubview(completeLabel)
        self.completeLabel.isHidden  = true
        self.customView.submitButton.setTitle("submitButtonText".localized, for: .normal)
        self.titleLabel.text = "markDownPageTitleLabel".localized
    }
    
    // Presenter ← View
    private func signUpButtonTapped() {
    }
    
    func submitAction(text:String) {
        presenter.submitButtonDisabled()
        var lines = [String]()
        
        text.enumerateLines { (line, stop) -> () in
            lines.append(line)
        }
        presenter.submitButtonTapped(input: text)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .autoreverse, animations: {
            self.completeLabel.isHidden = false
            self.completeLabel.center.y += 10.0
            self.completeLabel.text = "finished!!"
        }, completion: { (finished:Bool) in
            self.completeLabel.isHidden = true
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        defaults.register(defaults: ["FirstLaunch" : true])
        if defaults.bool(forKey: "FirstLaunch") == true {
            UserDefaults.standard.set(false, forKey: "FirstLaunch")
            let new_uuid = NSUUID().uuidString
            UserDefaults.standard.set(new_uuid, forKey: "uuid")
            self.customView.inputTextView.text = "tutorialTextViewContent".localized
            self.createUserData(uuid:new_uuid)
            let howToVC = R.storyboard.settings.howToPage()
            self.present(howToVC!, animated: true, completion: nil)
        }else{
            //２回目以降
            UserDefaults.standard.set(false, forKey: "FirstLaunch")
        }
    }
    
    private func createUserData(uuid:String){
        do {
            let realm = try Realm()
            let user = User(value: [ "uuid": uuid])
            try! realm.write {
                realm.add(user)
            }
        } catch {
            print("\(error)")
        }
    }

}

protocol MarkDownInputViewDelegate {
    func submitAction(text:String) -> Void
}
