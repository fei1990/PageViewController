//
//  FiPagerViewController.swift
//  PageControllerDemo
//
//  Created by wangfei on 2016/11/21.
//  Copyright © 2016年 fei.wang. All rights reserved.
//

import UIKit


let tabHeight = 44

let tabGap = 10  //标签间隙

class FiPagerViewController: UIViewController {

    fileprivate lazy var contentScrollView: UIScrollView? = {
        let scrollView: UIScrollView = UIScrollView(frame: CGRect(x: 0, y: 64, width: Int(self.view.frame.size.width), height: tabHeight))
        scrollView.autoresizingMask = .flexibleWidth
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.red
        scrollView.delegate = self
        return scrollView
    }()
    
    fileprivate lazy var pageViewController: UIPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    
    fileprivate var controllersArr: Array = [UIViewController]()
    
    private var tabTitleViewsArr: Array = [UILabel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        reloadDataForPager()
        
        (pageViewController.view.subviews[0] as! UIScrollView).delegate = self
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        defaultSelectedPageView(7)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func reloadDataForPager() {
        
        self.view.insertSubview(contentScrollView!, at: 0)
        
        
        var contentWidth: CGFloat = 0
        
        for index in 0..<numbersOfTab(self) {
            
            getViewController(index)
            
            let tabV: UIView = tabView(atIndex: index)
            
            contentScrollView?.addSubview(tabV)
            
            contentWidth += (tabV.frame.size.width + CGFloat(tabGap))
        }
        
        contentScrollView?.contentSize = CGSize(width: contentWidth + CGFloat(tabGap), height: CGFloat(tabHeight))
        
    }
    
    func defaultSelectedPageView(_ index: Int) {
        
        let contentVc = controllersArr[index]
        
        let tabTitleLbl = tabTitleViewsArr[index]
        
        let visibleRect = CGRect(x: (tabTitleLbl.frame.size.width + CGFloat(tabGap)) * CGFloat(index) + CGFloat(tabGap), y: CGFloat(0), width: tabTitleLbl.frame.size.width, height: CGFloat(tabHeight))
        DispatchQueue.main.async {
            self.pageViewController.setViewControllers([contentVc], direction: .forward, animated: true, completion: nil)
            self.contentScrollView?.scrollRectToVisible(visibleRect, animated: true)
        }
        
        
        
        
    }
    
    
    /// 创建tabView指定位置的lbl
    ///
    /// - Parameter index: tabView的索引位置
    /// - Returns: 返回创建好的view
    private func tabView(atIndex index: Int) -> UIView! {
        
        let tabText = tabContent(self, atIndex: index)
        let tabTextWidth: CGFloat = tabText.textWidth(CGFloat(tabHeight), fontSize: 14)
        let lbl: UILabel = UILabel()
        lbl.tag = index
        lbl.backgroundColor = UIColor.cyan
        lbl.numberOfLines = 1
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.text = tabText
        lbl.isUserInteractionEnabled = true
        lbl.frame = CGRect(x: CGFloat(tabTextWidth + CGFloat(tabGap)) * CGFloat(index) + CGFloat(tabGap), y: 0.0, width: tabTextWidth, height: CGFloat(tabHeight))
//        lbl.sizeToFit()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tabViewTapped(_:)))
        lbl.addGestureRecognizer(tapGesture)
        
        tabTitleViewsArr.append(lbl)
        
        return lbl
    }
    
    
    
    /// 获取要显示的controller
    ///
    /// - Parameter index: 相应位置
    func getViewController(_ index: Int) {
        let contentVc = controllersForPager(self, index)
        controllersArr.append(contentVc)
    }
    
    
    /// 根据位置索引从controllersArr取出相应controller
    ///
    /// - Parameter index: 位置索引
    /// - Returns: 返回对应controller
    func viewController(_ index: Int) -> UIViewController? {
        
        guard (index >= 0 || index < controllersArr.count) else {
            return nil
        }
        
        return controllersArr[index]
    }
    
    @objc private func tabViewTapped(_ tap: UIGestureRecognizer) {
        debugPrint((tap.view as! UILabel).tag)
    }
    
    
    func numbersOfTab(_ pager: FiPagerViewController) -> Int {
        return 12
    }
    
    func tabContent(_ pager: FiPagerViewController, atIndex index: Int) -> String {
        return "rrrrfdsfsafdsafs"
    }
    
    func controllersForPager(_: FiPagerViewController, _ atIndex: Int) -> UIViewController {
        return UIViewController()
    }

}


extension FiPagerViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index: Int = controllersArr.index(of: viewController)!
        
        index = index - 1
        
        return self.viewController(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index: Int = controllersArr.index(of: viewController)!
        
        index = index + 1
        
        return self.viewController(index)
    }
}

extension FiPagerViewController: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == contentScrollView {
            debugPrint(scrollView.contentOffset.x)
        }
        if scrollView == pageViewController.view.subviews[0] {
            
        }
    }
    
}


extension String {
    
    public func textWidth(_ maxHeight: CGFloat, fontSize: CGFloat) -> CGFloat {
        
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: fontSize)]
        let size = CGSize(width: CGFloat(Float.infinity), height: maxHeight)
        
        let rect = (self as NSString).boundingRect(with: size, options: NSStringDrawingOptions.usesFontLeading, attributes: attributes, context: nil)
        
        return rect.size.width
        
    }
    
}

