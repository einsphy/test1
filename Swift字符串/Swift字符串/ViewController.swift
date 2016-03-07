//
//  ViewController.swift
//  Swift字符串
//
//  Created by einsphy on 16/3/5.
//  Copyright © 2016年 einsphy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    
    let empty = "qwewe"
        print(empty)
        let full = "full is a lot of string"
        print(full)
        let afullCopy = full
        print(afullCopy)
    
        let char:Character = "a"
        print(char)
        
        for char1 in full.characters
        {
        
        
            print(char1)
        
        }
        
        
        let char2:[Character] = ["w","e","r","t"]
        let string1 = String(char2)
        print(string1)
        
    
    }

    

}

