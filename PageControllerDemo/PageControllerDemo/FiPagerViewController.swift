//
//  FiPagerViewController.swift
//  PageControllerDemo
//
//  Created by wangfei on 2016/11/21.
//  Copyright © 2016年 fei.wang. All rights reserved.
//

import UIKit


let tabHeight = 26

let tabGap = 10  //标签间隙

class FiPagerViewController: UIViewController {
    
    fileprivate lazy var tabTitleSArr: Array = ["fdsf0","fdsfds1","fdsatree2","fdsgfdggrh3","gtrhrggdsgfds4","f5","fds6","fdsafdsa7","fdsafdsagfdsbgfd8","fdsfdsafdsaa9","dfsawe10","dfaefwa11"]

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
    
    /// 记录titleLbl的横坐标
    private var tabTitleView_X: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "返回", style: .plain, target: self, action: #selector(FiPagerViewController.dismissVc))
        
        reloadDataForPager()
        
        pageViewControllerSet()
        
        defaultSelectedPageView(10)
        
        
        let v = UIView(frame: CGRect(x: 0, y: (contentScrollView?.frame)!.height + (contentScrollView?.frame)!.origin.y, width: (contentScrollView?.frame.size.width)!/2, height: 400))
        v.backgroundColor = UIColor.purple
        self.view.addSubview(v)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissVc() {
        self.dismiss(animated: true, completion: nil)
    }
    

    /// reload
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
        debugPrint("contentsize: \(contentScrollView?.contentSize.width)")
    }
    
    /// 添加pageViewController到self上
    private func pageViewControllerSet() {
        
        (pageViewController.view.subviews[0] as! UIScrollView).delegate = self
        pageViewController.delegate = self
        pageViewController.dataSource = self
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        pageViewController.view.backgroundColor = UIColor.purple
        let pageView_Y = (contentScrollView?.frame)!.height + (contentScrollView?.frame)!.origin.y
        
        pageViewController.view.frame = CGRect(x: 0, y: pageView_Y, width: self.view.frame.size.width, height: self.view.frame.size.height - pageView_Y)
        
    }
    
    /// 默认显示第几个controller 一般情况显示第一个
    ///
    /// - Parameter index: 索引
    private func defaultSelectedPageView(_ index: Int) {
        
        assert(index >= 0 && index < controllersArr.count, "index必须大于等于零 小于controllersArr.count")
        
        let contentVc = self.contentViewController(index)
        
        let visibleRect = tabTitleLblVisibleRect(index)
        
        DispatchQueue.main.async {
            self.pageViewController.setViewControllers([contentVc!], direction: .forward, animated: true, completion: nil)
            self.contentScrollView?.scrollRectToVisible(visibleRect, animated: true)
        }
        
    }
    
    /// tabTitleView滚动到的可视区域
    ///
    /// - Parameter index: index
    /// - Returns: 返回可视区域
    private func tabTitleLblVisibleRect(_ index: Int) -> CGRect {
        assert(index >= 0 && index < tabTitleViewsArr.count, "index必须大于等于零 小于controllersArr.count")
        
        let tabTitleLbl = tabTitleViewsArr[index]
        
        let rect: CGRect = CGRect(x: tabTitleLbl.frame.origin.x, y: CGFloat(0), width: tabTitleLbl.frame.size.width + ((contentScrollView?.frame.size.width)!/2 - tabTitleLbl.frame.size.width/2), height: CGFloat(tabHeight))
        return rect
//        return CGRect(x: (tabTitleLbl.frame.size.width + CGFloat(tabGap)) * CGFloat(index) + CGFloat(tabGap) + self.view.frame.size.width/2 - tabTitleLbl.frame.size.width/2 - CGFloat(tabGap)/4, y: CGFloat(0), width: tabTitleLbl.frame.size.width, height: CGFloat(tabHeight))
    }
    
    
    /// 创建tabView指定位置的lbl
    ///
    /// - Parameter index: tabView的索引位置
    /// - Returns: 返回创建好的view
    private func tabView(atIndex index: Int) -> UIView! {
        
        tabTitleView_X += CGFloat(tabGap) + ((tabTitleViews(index-1) == nil) ? 0 : (tabTitleViews(index-1)! as UILabel).frame.size.width)
        
        let tabText = tabContent(self, atIndex: index)
        let tabTextWidth: CGFloat = tabText.textWidth(CGFloat(tabHeight), fontSize: 14)
        let lbl: UILabel = UILabel()
        lbl.tag = index
        lbl.backgroundColor = UIColor.cyan
        lbl.numberOfLines = 1
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.text = tabText
        lbl.isUserInteractionEnabled = true
        lbl.frame = CGRect(x: tabTitleView_X, y: 0.0, width: tabTextWidth, height: CGFloat(tabHeight))
        
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
    func contentViewController(_ index: Int) -> UIViewController? {
        guard (index >= 0 && index < controllersArr.count) else {
            return nil
        }
        return controllersArr[index]
    }
    
    /// 根据索引取出titleLbl
    ///
    /// - Parameter index: 索引
    /// - Returns: 返回titleLbl
    private func tabTitleViews(_ index: Int) -> UILabel? {
        guard ((index >= 0 && index < tabTitleViewsArr.count) && tabTitleViewsArr.count > 0) else {
            return nil
        }
        return tabTitleViewsArr[index]
    }
    
    /// 取contentVc在容器中的索引位置
    ///
    /// - Parameter contentVc: 内容controller
    /// - Returns: 返回该controller的索引
    fileprivate func index(ofVc contentVc: UIViewController) -> Int {
        return controllersArr.index(of: contentVc)!
    }
    
    @objc private func tabViewTapped(_ tap: UIGestureRecognizer) {
        debugPrint((tap.view as! UILabel).tag)
        let index = (tap.view as! UILabel).tag
        let contentVc = controllersArr[index]
        self.pageViewController.setViewControllers([contentVc], direction: .forward, animated: true, completion: nil)
    }
    
    
    func numbersOfTab(_ pager: FiPagerViewController) -> Int {
        return tabTitleSArr.count
    }
    
    func tabContent(_ pager: FiPagerViewController, atIndex index: Int) -> String {
        return tabTitleSArr[index]
    }
    
    func controllersForPager(_: FiPagerViewController, _ atIndex: Int) -> UIViewController {
        return MyTableViewController()
    }

}


extension FiPagerViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index: Int = controllersArr.index(of: viewController)!
        
        index = index - 1
        
        return self.contentViewController(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index: Int = controllersArr.index(of: viewController)!
        
        index = index + 1
        
        return self.contentViewController(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
//        debugPrint(pendingViewControllers.count)
        
        let vc = pendingViewControllers[0] as! MyTableViewController
        
        let index = self.index(ofVc: vc)
        
        debugPrint(index)
    }
}

extension FiPagerViewController: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == contentScrollView {
            debugPrint(scrollView.contentOffset.x)
        }
        if scrollView == pageViewController.view.subviews[0] {
//            debugPrint(scrollView.contentOffset.x)
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


/// Test
class MyTableViewController: UITableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\((indexPath as NSIndexPath).row)"
        return cell
    }
}

