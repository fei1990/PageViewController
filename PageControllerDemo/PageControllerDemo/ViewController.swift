//
//  ViewController.swift
//  PageControllerDemo
//
//  Created by wangfei on 2016/11/19.
//  Copyright © 2016年 fei.wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var pageController: UIPageViewController? = nil
    
    lazy var pageContentArr: [String] = [String]()
    
    lazy var slider: UISlider = {
        let sli: UISlider = UISlider(frame: CGRect(x: 40, y: 400, width: self.view.frame.size.width - 80, height: 30))
        sli.addTarget(self, action: #selector(valueChanged(slider:)), for: .valueChanged)
        
        return sli
        
    }()
    
    
    fileprivate lazy var contentScrollView: UIScrollView? = {
        let scrollView: UIScrollView = UIScrollView(frame: CGRect(x: 55, y: 64, width: Int(self.view.frame.size.width)/2, height: 200))
        scrollView.autoresizingMask = .flexibleWidth
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.red
        scrollView.contentSize = CGSize(width: 900, height: 200)
        scrollView.clipsToBounds = false
        return scrollView
    }()
    
    fileprivate lazy var lbl0: UILabel! = {
        let lab = UILabel(frame: CGRect(x: (self.contentScrollView?.frame.size.width)!/2 - 20, y: 40, width: 40, height: 20))
        lab.backgroundColor = UIColor.cyan
        lab.text = "ddd"
        return lab
    }()
    
    fileprivate lazy var lbl: UILabel! = {
        let lab = UILabel(frame: CGRect(x: 200, y: 40, width: 90, height: 20))
        lab.backgroundColor = UIColor.cyan
        lab.text = "sss"
        return lab
    }()
    
    
    func pushNextVc() {
        let pageVc = FiPagerViewController()
//        self.navigationController?.pushViewController(pageVc, animated: true)
        let na = UINavigationController(rootViewController: pageVc)
        self.navigationController?.present(na, animated: true, completion: nil)
        
//        let rect: CGRect = CGRect(x: 230, y: 80, width: 40 + (contentScrollView!.frame.size.width/2 - 20), height: 20)
//        contentScrollView?.scrollRectToVisible(rect, animated: true)
        
        
//        let rect: CGRect = CGRect(x: 245, y: 40, width: 90, height: 20)
//        contentScrollView?.scrollRectToVisible(rect, animated: true)
        
    }
    
    func valueChanged(slider: UISlider) {
        print(slider.value)
        
        let value: CGFloat = CGFloat(slider.value)
        
        let x_diff = (lbl.frame.minX - lbl0.frame.minX) * value + lbl0.frame.minX
        
//        print("x_diff = \(x_diff)")
        
        
        let width_diff = (lbl0.frame.width + (lbl.frame.width - lbl0.frame.width) * value)/2 + (contentScrollView?.frame.width)!/2
        
//        print("width_diff = \(width_diff)")
        
        let rect = CGRect(x: x_diff, y: 40, width: width_diff, height: 20)
        contentScrollView?.scrollRectToVisible(rect, animated: false)
        print(rect)
        
//        let point: CGPoint = CGPoint(x: value*(contentScrollView?.frame.width)!, y: 0)
//        contentScrollView?.setContentOffset(point, animated: false)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(contentScrollView!)
        
//        contentScrollView?.addSubview(lbl0)
        contentScrollView?.addSubview(lbl)
        
        self.view.addSubview(slider)
        
        let btn: UIButton = UIButton(type: .system)
        btn.setTitle("push", for: .normal)
        btn.frame = CGRect(x: 50, y: 300, width: 60, height: 40)
        btn.addTarget(self, action: #selector(pushNextVc), for: .touchUpInside)
        self.view.addSubview(btn)
        
        let testModule = SubClass1()
        testModule.foo()
        testModule.bar()
        testModule.baz()
        
        for i in 0..<10 {
            let string = "This is the page \(i) of content displayd using UIPageViewController"
            pageContentArr.append(string)
        }
        
        let options = [UIPageViewControllerOptionInterPageSpacingKey : "20"]
        
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
//        pageController?.isDoubleSided = true
        
        pageController?.delegate = self
        pageController?.dataSource = self
        
        let initialVc = viewController(atIndexPath: 0)
        let viewControllers:Array<ContentViewController> = [initialVc!]
        
        pageController?.setViewControllers(viewControllers, direction: .reverse, animated: false, completion: { (finished) in
            
        })
        
//        pageController?.view.frame = self.view.frame
//        addChildViewController(pageController!)
//        view.addSubview((pageController?.view)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func viewController(atIndexPath indexPath: Int) -> ContentViewController? {
        if pageContentArr.count == 0 || indexPath >= pageContentArr.count {
            return nil
        }
        let contentVc = ContentViewController()
        contentVc.content = pageContentArr[indexPath]
        return contentVc
    }
    
    
    func index(ofViewController vc: ContentViewController) -> Int {
        return pageContentArr.index(of: vc.content)!
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = self.index(ofViewController: viewController as! ContentViewController)
        if index == 0 || index == NSNotFound {
            return nil
        }
        
        index = index-1
        
        return self.viewController(atIndexPath: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = self.index(ofViewController: viewController as! ContentViewController)
        if index == NSNotFound {
            return nil
        }
        
        index = index + 1
        
        if index == pageContentArr.count {
            return nil
        }
        return self.viewController(atIndexPath: index)
    }

}

