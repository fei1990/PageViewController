//
//  ContentViewController.swift
//  PageControllerDemo
//
//  Created by wangfei on 2016/11/19.
//  Copyright © 2016年 fei.wang. All rights reserved.
//

import UIKit

let kRandomColor = UIColor.init(colorLiteralRed: Float(arc4random_uniform(256))/255.0, green: Float(arc4random_uniform(256))/255.0, blue: Float(arc4random_uniform(256))/255.0, alpha: 1.0)


class ContentViewController: UIViewController {
    
    
    var content: String = "" {
        willSet{
            contentLabel.text = newValue
        }
    }
    
    lazy var contentLabel: UILabel = {
        let lbl = UILabel(frame: CGRect(x: 0, y: 50, width: self.view.bounds.size.width, height: 100))
        lbl.numberOfLines = 0
        lbl.backgroundColor = kRandomColor
        lbl.text = "fdosjalfkjdsljfkldsjklafjfldsjalk"
        return lbl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(contentLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
