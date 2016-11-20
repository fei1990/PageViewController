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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        
        pageController?.view.frame = self.view.frame
        addChildViewController(pageController!)
        view.addSubview((pageController?.view)!)
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

