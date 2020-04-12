//
//  InstructionsViewController.swift
//  ClassroomConnections
//
//  Created by Michael Peng on 4/9/20.
//  Copyright © 2020 CodifyAsia. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var name: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        logo.isHidden = true
        name.isHidden = true
         self.scrollView.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height)
                let scrollViewWidth:CGFloat = self.scrollView.frame.width
                let scrollViewHeight:CGFloat = self.scrollView.frame.height
                //2
                textView.textAlignment = .center
                textView.text = "Classroom connections is a remote chatting app that helps foster bonds between teachers and students to encourage a healthy  educational communities within classes."
        textView.textColor = UIColor.black
                self.startButton.layer.cornerRadius = 4.0
                //3
                let imgOne = UIImageView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight))
                imgOne.image = UIImage(named: "slide1")
                let imgTwo = UIImageView(frame: CGRect(x:scrollViewWidth, y:0,width:scrollViewWidth, height:scrollViewHeight))
                imgTwo.image = UIImage(named: "slide2")
                let imgThree = UIImageView(frame: CGRect(x:scrollViewWidth*2, y:0,width:scrollViewWidth, height:scrollViewHeight))
                imgThree.image = UIImage(named: "slide3")
                let imgFour = UIImageView(frame: CGRect(x:scrollViewWidth*3, y:0,width:scrollViewWidth, height:scrollViewHeight))
                imgFour.image = UIImage(named: "Slide 4")
                
        
                self.scrollView.addSubview(imgOne)
                self.scrollView.addSubview(imgTwo)
                self.scrollView.addSubview(imgThree)
                self.scrollView.addSubview(imgFour)
                //4
                self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * 4, height:self.scrollView.frame.height)
                self.scrollView.delegate = self
                self.pageControl.currentPage = 0
            }

            override func didReceiveMemoryWarning() {
                super.didReceiveMemoryWarning()
                // Dispose of any resources that can be recreated.
            }
        }
        private typealias ScrollView = InstructionsViewController
        extension ScrollView
        {
            func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
                // Test the offset and calculate the current page after scrolling ends
                let pageWidth:CGFloat = scrollView.frame.width
                let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
                // Change the indicator
                self.pageControl.currentPage = Int(currentPage);
                // Change the text accordingly
                if Int(currentPage) == 0{
                    textView.text = "Classroom connections is a remote chatting app that helps foster bonds between teachers and students to encourage a healthy  educational communities within classes."
                }else if Int(currentPage) == 1{
                    
                    
                    textView.text = "Including many features such as conflict calenders, personalized chat rooms, and question and answer systems, classroom connections could be a teachers greatest tool to build educational bonds with their students."
                }else if Int(currentPage) == 2{
                    textView.text = "In addition, classroom connections is extremely user-friendly and very easy to use. It is designed to create the most pleasent user experience suitable in an educational environement."
                }else{
                    textView.text = "Get ready to build some amazing connections inside your classroom."
                    // Show the "Let's Start" button in the last slide (with a fade in animation)
                    logo.isHidden = false
                    name.isHidden = false
                    logo.alpha = 0
                    name.alpha = 0
                    UIView.animate(withDuration: 1.0, animations: { () -> Void in
                        self.startButton.alpha = 1.0
                    })
                    UIView.animate(withDuration: 1.0, animations: { () -> Void in
                        self.logo.alpha = 1.0
                    })
                    UIView.animate(withDuration: 1.0, animations: { () -> Void in
                        self.name.alpha = 1.0
                    })
                }
            }
        }
