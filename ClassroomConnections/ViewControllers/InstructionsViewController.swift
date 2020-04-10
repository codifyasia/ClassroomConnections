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
    override func viewDidLoad() {
        super.viewDidLoad()
         self.scrollView.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height)
                let scrollViewWidth:CGFloat = self.scrollView.frame.width
                let scrollViewHeight:CGFloat = self.scrollView.frame.height
                //2
                textView.textAlignment = .center
                textView.text = "Sweettutos.com is your blog of choice for Mobile tutorials"
                textView.textColor = UIColor.black
                self.startButton.layer.cornerRadius = 4.0
                //3
                let imgOne = UIImageView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight))
                imgOne.image = UIImage(named: "Slide 1")
                let imgTwo = UIImageView(frame: CGRect(x:scrollViewWidth, y:0,width:scrollViewWidth, height:scrollViewHeight))
                imgTwo.image = UIImage(named: "Slide 2")
                let imgThree = UIImageView(frame: CGRect(x:scrollViewWidth*2, y:0,width:scrollViewWidth, height:scrollViewHeight))
                imgThree.image = UIImage(named: "Slide 3")
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
                    textView.text = "Sweettutos.com is your blog of choice for Mobile tutorials"
                }else if Int(currentPage) == 1{
                    textView.text = "I write mobile tutorials mainly targeting iOS"
                }else if Int(currentPage) == 2{
                    textView.text = "And sometimes I write games tutorials about Unity"
                }else{
                    textView.text = "Keep visiting sweettutos.com for new coming tutorials, and don't forget to subscribe to be notified by email :)"
                    // Show the "Let's Start" button in the last slide (with a fade in animation)
                    UIView.animate(withDuration: 1.0, animations: { () -> Void in
                        self.startButton.alpha = 1.0
                    })
                }
            }
        }
