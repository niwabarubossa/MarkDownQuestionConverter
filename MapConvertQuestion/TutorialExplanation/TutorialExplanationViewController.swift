//
//  TutorialExplanationViewController.swift
//  cbt_diary
//
//  Created by 丹羽遼吾 on 2020/02/28.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit

class TutorialExplanationViewController: UIViewController,UIScrollViewDelegate {
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var dismissButton: UIButton!
    
    let PAGE_CONTROL_HEIGHT:CGFloat = 37.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myScrollView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        let tutorialContentArray:[TutorialContentModel] = TutorialContentModel.createModels()
        let parentWidth:CGFloat = view.frame.width
        let parentHeight:CGFloat = view.frame.height
        var counter:CGFloat = 0
        for tutorialContent in tutorialContentArray.enumerated() {
            let xibView = TutorialExplanationUIView(frame: CGRect(x: 0 + (parentWidth * counter), y: 0, width: parentWidth, height: parentHeight - PAGE_CONTROL_HEIGHT ))
            xibView.tutorialTitleLabel.text = tutorialContent.element.title
            let font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight(300))
            xibView.tutorialTitleLabel.font = font
            xibView.tutorialContentLabel.text = tutorialContent.element.content
            xibView.tutorialIconImage.image = tutorialContent.element.imageIcon
            self.myScrollView.addSubview(xibView)
            counter += 1
        }
        let arrayCountCGFloat:CGFloat = CGFloat(tutorialContentArray.count)
        myScrollView.contentSize = CGSize(width: myScrollView.frame.size.width * arrayCountCGFloat,
                                         height: myScrollView.frame.size.height)
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension TutorialExplanationViewController{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(myScrollView.contentOffset.x / myScrollView.frame.size.width)
    }
}
