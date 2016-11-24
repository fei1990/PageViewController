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
    
    
    fileprivate lazy var contentScrollView: UIScrollView? = {
        let scrollView: UIScrollView = UIScrollView(frame: CGRect(x: 55, y: 64, width: Int(self.view.frame.size.width)/2, height: 200))
        scrollView.autoresizingMask = .flexibleWidth
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.red
        scrollView.contentSize = CGSize(width: 500, height: 200)
        scrollView.clipsToBounds = false
        return scrollView
    }()
    
    fileprivate lazy var lbl0: UILabel! = {
        let lab = UILabel(frame: CGRect(x: self.view.frame.size.width/5, y: 80, width: 40, height: 20))
        lab.backgroundColor = UIColor.cyan
        lab.text = "ddd"
        return lab
    }()
    
    fileprivate lazy var lbl: UILabel! = {
        let lab = UILabel(frame: CGRect(x: 230, y: 40, width: 40, height: 20))
        lab.backgroundColor = UIColor.cyan
        lab.text = "ddd"
        return lab
    }()
    
    
    func pushNextVc() {
        let pageVc = FiPagerViewController()
//        self.navigationController?.pushViewController(pageVc, animated: true)
        let na = UINavigationController(rootViewController: pageVc)
        self.navigationController?.present(na, animated: true, completion: nil)
        
//        let rect: CGRect = CGRect(x: 230, y: 80, width: 40 + (contentScrollView!.frame.size.width/2 - 20), height: 20)
//        contentScrollView?.scrollRectToVisible(rect, animated: true)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(contentScrollView!)
        
        contentScrollView?.addSubview(lbl0)
        contentScrollView?.addSubview(lbl)
        
        
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

