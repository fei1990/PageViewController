//
//  FiPagerViewController.swift
//  PageControllerDemo
//
//  Created by wangfei on 2016/11/21.
//  Copyright © 2016年 fei.wang. All rights reserved.
//

import UIKit

enum PageScrollState {
    case none
    case tap
    case swipe
}

private let tabHeight: CGFloat = 30

private let tabGap: CGFloat = 25  //标签间隙

private let SCALE_FACTOR = CGFloat(0.2)

private let MAXSCALE_FACTOR = CGFloat(1.2)

private let MINSCALE_FACTOR = MAXSCALE_FACTOR - SCALE_FACTOR

class FiPagerViewController: UIViewController {
    
    fileprivate lazy var tabTitleSArr: Array = ["fdsf0","fdsfds1","fdsatree2","fdsgfdggrh3","gtrhrggdsgfds4","f5","fds6","fdsafdsa7","fdsafdsagfdsbgfd8","fdsfdsafdsaa9","dfsawe10","dfaefwa11","fdsafds12","fsfdsf13","fsfsafsfsdf14","fd15","fsf16"]

    
       // ["头条","头条","头条","头条","头条","头条","头条","头条","头条","头条","头条","头条","头条","头条","头条","头条","头条"]//
    private lazy var contentView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor.red
        return view
    }()
    
    fileprivate lazy var contentScrollView: UIScrollView? = {
        let scrollView: UIScrollView = UIScrollView(frame: CGRect(x: 0, y: 64, width: Int(self.view.frame.size.width), height: Int(tabHeight)))
        scrollView.autoresizingMask = .flexibleWidth
        scrollView.scrollsToTop = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.backgroundColor = UIColor.red
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = false
        
        scrollView.addSubview(self.contentView)
        return scrollView
    }()
    
    fileprivate lazy var pageViewController: UIPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    
    fileprivate var controllersArr: Array = [UIViewController]()
    
    fileprivate var tabTitleViewsArr: Array = [UILabel]()
    
    /// 记录titleLbl的横坐标
    private var tabTitleView_X: CGFloat = 0
    
    fileprivate var currentTabLbl: UILabel!
    
    fileprivate var pageScrollState: PageScrollState = .none
    
    fileprivate var nextTabLbl: UILabel!
    
    fileprivate var visibleRect_X: CGFloat = tabGap
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "返回", style: .plain, target: self, action: #selector(FiPagerViewController.dismissVc))
        
        reloadDataForPager()
        
        pageViewControllerSet()
        
        defaultSelectedPageView(5)
        
        
//        let v = UIView(frame: CGRect(x: 0, y: (contentScrollView?.frame)!.height + (contentScrollView?.frame)!.origin.y, width: (contentScrollView?.frame.size.width)!/2, height: 400))
//        v.backgroundColor = UIColor.purple
//        self.view.addSubview(v)
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
            
            contentView.addSubview(tabV)
            
            contentWidth += (tabV.frame.size.width + CGFloat(tabGap))
            
            
        }
        contentView.frame = CGRect(x: 0, y: 0, width: contentWidth + CGFloat(tabGap), height: CGFloat(tabHeight))
        contentScrollView?.contentSize = CGSize(width: contentWidth + CGFloat(tabGap), height: CGFloat(tabHeight))
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
        
        currentTabLbl = tabTitleView(index)
        
        let contentVc = self.contentViewController(index)
        
        let visibleRect = tabTitleLblVisibleRect(index)
        
        DispatchQueue.main.async {
            self.currentTabLbl.layer.transform = CATransform3DMakeScale(MAXSCALE_FACTOR, MAXSCALE_FACTOR, MAXSCALE_FACTOR)
            self.pageViewController.setViewControllers([contentVc!], direction: .forward, animated: true, completion: nil)
            self.contentScrollView?.scrollRectToVisible(visibleRect, animated: false)
        }
        
    }
    
    /// 创建tabView指定位置的lbl
    ///
    /// - Parameter index: tabView的索引位置
    /// - Returns: 返回创建好的view
    private func tabView(atIndex index: Int) -> UIView! {
        
        tabTitleView_X += CGFloat(tabGap) + ((tabTitleView(index-1) == nil) ? 0 : (tabTitleView(index-1)! as UILabel).frame.size.width)
        
        let tabText = tabContent(self, atIndex: index)
        let tabTextWidth: CGFloat = tabText.textWidth(CGFloat(tabHeight), fontSize: 16)
        let lbl: UILabel = UILabel()
        lbl.tag = index
//        lbl.backgroundColor = UIColor.cyan
        lbl.numberOfLines = 1
        lbl.font = UIFont.systemFont(ofSize: 16)
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
    fileprivate func tabTitleView(_ index: Int) -> UILabel? {
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
    
    /// tabTitleView滚动到的可视区域
    ///
    /// - Parameter index: index
    /// - Returns: 返回可视区域
    private func tabTitleLblVisibleRect(_ index: Int) -> CGRect {
        assert(index >= 0 && index < tabTitleViewsArr.count, "index必须大于等于零 小于controllersArr.count")
        
        self.currentTabLbl = tabTitleView(index)
        
        self.visibleRect_X = self.currentTabLbl.frame.minX - ((self.contentScrollView?.frame.width)!/2 - self.currentTabLbl.frame.width/2)
        
        let rect = CGRect(x: self.visibleRect_X, y: self.currentTabLbl.frame.minY, width: (self.contentScrollView?.frame.width)!, height: self.currentTabLbl.frame.height)
        
        return rect
    }
    
    fileprivate func tabMovedWithOffsetRatio(_ offsetRatio: CGFloat) {
        
        if self.pageScrollState == .none {
            return
        }
        
        if self.pageScrollState == .swipe {
            
            tabTitleViewTransform(offsetRatio)
            
            let rect = CGRect(x: visibleRect_X + (self.nextTabLbl.frame.width/2 + self.currentTabLbl.frame.width/2 + tabGap) * offsetRatio, y: self.currentTabLbl.frame.minY, width: (self.contentScrollView?.frame.width)!, height: self.currentTabLbl.frame.height)
            contentScrollView?.scrollRectToVisible(rect, animated: false)
        }
        
    }
    
    fileprivate func tabTitleViewTransform(_ offsetRatio: CGFloat) {
        
        self.nextTabLbl.layer.transform = CATransform3DMakeScale((MINSCALE_FACTOR + CGFloat(fabsf(Float(offsetRatio))) * SCALE_FACTOR), (MINSCALE_FACTOR + CGFloat(fabsf(Float(offsetRatio))) * SCALE_FACTOR), (MINSCALE_FACTOR + CGFloat(fabsf(Float(offsetRatio))) * SCALE_FACTOR))
        
        self.currentTabLbl.layer.transform = CATransform3DMakeScale((MAXSCALE_FACTOR - CGFloat(fabsf(Float(offsetRatio))) * SCALE_FACTOR), (MAXSCALE_FACTOR - CGFloat(fabsf(Float(offsetRatio))) * SCALE_FACTOR), (MAXSCALE_FACTOR - CGFloat(fabsf(Float(offsetRatio))) * SCALE_FACTOR))
    }
    
    
    @objc private func tabViewTapped(_ tap: UIGestureRecognizer) {
        
        self.pageScrollState = .tap
        
        self.currentTabLbl.layer.transform = CATransform3DMakeScale(MINSCALE_FACTOR, MINSCALE_FACTOR, MINSCALE_FACTOR)
        
        let currentIndex = (tap.view as! UILabel).tag
        
        let rect = tabTitleLblVisibleRect(currentIndex)
        
        self.contentScrollView?.scrollRectToVisible(rect, animated: true)
        
        self.currentTabLbl.layer.transform = CATransform3DMakeScale(MAXSCALE_FACTOR, MAXSCALE_FACTOR, MAXSCALE_FACTOR)
        
        let contentVc = contentViewController(currentIndex)!
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
        
        self.pageScrollState = .swipe
        
        let currentIndex: Int = self.index(ofVc: pageViewController.viewControllers![0] as! MyTableViewController)
        
        self.currentTabLbl = self.tabTitleView(currentIndex)
        
        let pendingIndex: Int = self.index(ofVc: pendingViewControllers[0] as! MyTableViewController)
        
        self.nextTabLbl = self.tabTitleView(pendingIndex)
        
        self.visibleRect_X = self.currentTabLbl.frame.minX - ((self.contentScrollView?.frame.width)!/2 - self.currentTabLbl.frame.width/2)
        
//        debugPrint("currentIndex: \(currentIndex)...... pendingIndex: \(pendingIndex)")
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            let currentIndex: Int = self.index(ofVc: pageViewController.viewControllers![0] as! MyTableViewController)
            self.currentTabLbl = self.tabTitleView(currentIndex)
//            self.pageScrollState = .none
            debugPrint("finished: \(currentIndex)")
        }else {
//            debugPrint("uncompleted")
        }
        
    }
    
}

extension FiPagerViewController: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == contentScrollView {
            
        }
        if scrollView == pageViewController.view.subviews[0] {
            let ratio = scrollView.contentOffset.x/scrollView.frame.width - 1
            if ratio == 0 {
                self.pageScrollState = .none
            }
            tabMovedWithOffsetRatio(ratio)
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
        return 20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\((indexPath as NSIndexPath).row)"
        return cell
    }
}

