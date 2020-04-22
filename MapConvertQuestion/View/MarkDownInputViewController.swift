import UIKit
import RealmSwift
import Instructions
import SwiftMessages
import SwiftEntryKit

class MarkDownInputViewController: UIViewController,MarkDownInputViewDelegate{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var customView: MarkDownInput!
    @IBOutlet weak var opinionFormButton: OpinionFormButton!
    var presenter:MarkDownInputPresenter!
    
    private let coachMarksController = CoachMarksController()
    private var pointOfInterest:UIView!
    private var tutorialContent:[String] = ["markdownTextViewCoachMark".localized,"markdownSubmitButtonCoachMark".localized]
    @IBOutlet weak var dummyStudyTabBar: UIView!
    lazy var tutorialPartsArray = [customView.inputTextView,customView.submitButton]
    
    override func viewDidLoad(){
        super.viewDidLoad()
        initializePresenter()
        layout()
        self.coachMarksController.dataSource = self
    }
    
    private func showFinishPopUP(){
        let titleText = "Finish"
        let descText = "let's start study!"
        let textColor = EKColor.white
        let titleFont = UIFont(name: LetGroup.boldFontName, size: 35)!
        let descFont = UIFont(name: LetGroup.boldFontName, size: 20)!
        let myImage = R.image.done()!
        var attributes = EKAttributes.centerFloat
        attributes.entryBackground = .color(color: EKColor.init(.green))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.1), scale: .init(from: 1, to: 0.7, duration: 0.3)))
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
        attributes.statusBar = .dark
        let minEdge = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        attributes.positionConstraints.maxSize = .init(width: .constant(value: minEdge), height: .intrinsic)
        let title = EKProperty.LabelContent(text: titleText, style: .init(font: titleFont, color: textColor))
        let description = EKProperty.LabelContent(text: descText, style: .init(font: descFont, color: textColor))
        let image = EKProperty.ImageContent(image: myImage, size: CGSize(width: 35, height: 35))
        let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    private func showFinish(){
        var attributes = EKAttributes.centerFloat
        attributes.position = .center
        attributes.displayDuration = .infinity
        attributes.entryBackground = .color(color: .white)
        attributes.entranceAnimation = .none
        attributes.exitAnimation = .translation
        attributes.screenInteraction = .dismiss
        let customView = UIView(frame: CGRect(x: 0, y: 0 , width: 300, height: 200))
        let widthConstraint = customView.widthAnchor.constraint(equalToConstant: 100)
        widthConstraint.isActive = true
        let heightConstraint = customView.heightAnchor.constraint(equalToConstant: 300)
        heightConstraint.isActive = true
        customView.backgroundColor = .orange
        SwiftEntryKit.display(entry: customView, using: attributes)
    }
    
    private func initializePresenter() {
       presenter = MarkDownInputPresenter(view: self)
    }
    
    func layout() {
        customView.myDelegate = self
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
        self.showFinishPopUP()
        let defaults = UserDefaults.standard
        defaults.register(defaults: ["IsFirstSubmit" : true])
        if defaults.bool(forKey: "IsFirstSubmit") == true{
            UserDefaults.standard.set(false, forKey: "IsFirstSubmit")
            self.tutorialPartsArray = [dummyStudyTabBar]
            self.tutorialContent = ["markdownTabCoachMark".localized]
            self.coachMarksController.start(in: .currentWindow(of: self))
        }
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

