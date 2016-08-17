//
//  ViewController.swift
//  CALayerTest
//
//  Created by liuzhimin on 17/08/2016.
//  Copyright © 2016 liuzhimin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let layer = LZMLayer(withNumberOfItems: 6)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.darkGray
        view.layer.addSublayer(layer)
        layer.color = UIColor.white
        spin(sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // Wire these up to two UIButtons on your Storyboard. But for now I'll just call the first above.
    
     func spin(sender: AnyObject?) {
        layer.startAnimating()
    }
    
     func halt(sender: AnyObject) {
        layer.stopAnimating()
    }
}

