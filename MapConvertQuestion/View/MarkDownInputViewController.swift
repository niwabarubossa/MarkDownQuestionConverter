import UIKit
import RealmSwift

class MarkDownInputViewController: UIViewController,MarkDownInputViewDelegate{
    
    @IBOutlet weak var customView: MarkDownInput!
    var presenter:MarkDownInputPresenter!
//    var customView = MarkDownInput()
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
//        customView = MarkDownInput(frame: CGRect(x: 0, y: 0, width: view.frame.width - 30, height: view.frame.height - 100))
//        customView.center = self.view.center
        customView.myDelegate = self
//        self.view.addSubview(customView)
        completeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 30, height: 100))
        completeLabel.backgroundColor = MyColor.fourthColor
        completeLabel.center = self.view.center
        completeLabel.textAlignment = .center
        completeLabel.text = "complete!!!!!!"
        self.view.addSubview(completeLabel)
        self.completeLabel.isHidden  = true
        self.customView.submitButton.setTitle("submitButtonText".localized, for: .normal)
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
             print("new!! \n \(new_uuid) \n\n")
            print("初回のログインです")
            self.customView.inputTextView.text = "チュートリアル\n\tどうやって問題に答えればいいの？\n\t\t正解したら左からスワイプ. 色が緑色に変わります！\n\t\t不正解だったら右からスワイプ, 色が赤に変わります！\n\t\tその日解くべき問題は白色です！　全ての問題に正解するまで問題は出題されます！\n\t第２章\n\t\t第２章って問題じゃないから出題してほしくないなぁ.. そんな時は 真ん中のボタンをタップ！　これ以降問題として表示されなくなります。\n\t\t全ての問題は、「一覧」ページでマップごとに確認することができます\n\t日本の首都は？\n\t\t東京\n\t\t答えでもあり、クイズでもあるノードには矢印があります ↓\n\t\tじゃあ 東京には何個区があるの？　タップしてみて！(クイズ兼答え）\n\t\t\t23\n\t\t\tこんな風に、クイズでもあり答えでもあるやつには矢印がついています！タップすると進めます！\n"

            self.createUserData(uuid:new_uuid)
            let howToVC = R.storyboard.settings.howToPage()
            self.present(howToVC!, animated: true, completion: nil)
        }else{
            UserDefaults.standard.set(false, forKey: "FirstLaunch")
            print("２回目以降のログインです")
        }
    }
    
    private func createUserData(uuid:String){
        do {
            let realm = try Realm()
            let user = User(value: [
                "uuid": uuid
            ])
            try! realm.write {
                realm.add(user)
                print("成功", user)
            }
        } catch {
            print("\(error)")
            print("エラーだよ")
        }
    }

    
}

protocol MarkDownInputViewDelegate {
    func submitAction(text:String) -> Void
}
