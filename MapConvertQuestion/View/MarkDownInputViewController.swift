import UIKit
import RealmSwift
import Instructions

class MarkDownInputViewController: UIViewController,MarkDownInputViewDelegate{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var customView: MarkDownInput!
    @IBOutlet weak var opinionFormButton: OpinionFormButton!
    var presenter:MarkDownInputPresenter!
    var completeLabel = UILabel()
    
    private let coachMarksController = CoachMarksController()
    private var pointOfInterest:UIView!
    private let tutorialContent:[String] = ["first Tutorial","secondTutorial","startStudy!!"]
    @IBOutlet weak var dummyStudyTabBar: UIView!
    lazy var tutorialPartsArray = [customView.inputTextView,customView.submitButton,dummyStudyTabBar]
    
    override func viewDidLoad(){
        super.viewDidLoad()
        initializePresenter()
        layout()

        self.coachMarksController.dataSource = self
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
        defaults.register(defaults: ["InputPageFirstLaunch" : true])
        if defaults.bool(forKey: "InputPageFirstLaunch") == true {
            UserDefaults.standard.set(false, forKey: "InputPageFirstLaunch")
            self.customView.inputTextView.text = "tutorialTextViewContent".localized
            self.coachMarksController.start(in: .currentWindow(of: self))
        }else{ //２回目以降
            UserDefaults.standard.set(false, forKey: "InputPageFirstLaunch")
        }
    }

}

extension MarkDownInputViewController{
    private func showTutorial(){
        
    }
}

protocol MarkDownInputViewDelegate {
    func submitAction(text:String) -> Void
}
    
extension MarkDownInputViewController:CoachMarksControllerDataSource, CoachMarksControllerDelegate{
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return self.tutorialContent.count
    }

    func coachMarksController(_ coachMarksController: CoachMarksController,
                                  coachMarkAt index: Int) -> CoachMark {
        return coachMarksController.helper.makeCoachMark(for: self.tutorialPartsArray[index])
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, withNextText: true, arrowOrientation: coachMark.arrowOrientation)
        coachViews.bodyView.hintLabel.text = self.tutorialContent[index]
        coachViews.bodyView.nextLabel.text = "OK"
        coachViews.bodyView.nextLabel.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
}

