//
//  ViewController.swift
//  TitansSwiftProject
//
//  Created by desmond on 6/23/14.
//  Copyright (c) 2014 Phoenix. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //new add
        // Example #1
        //
        uploadFile().then({
            // let the user know their file has been uploaded
            println("hooray, your file uploaded!")
            }).then({
                // do something else here
                println("start next file upload, or something equally interesting")
                }).fail({
                    // alert the user that their file upload failed miserably
                    println("all is lost. accept defeat.")
                    }).done({
                        // we're done!
                        println("all done!")
                        })
        
        //
        // Example #2
        //
        uploadFile().then({
            // let the user know their file has been uploaded
            println("hooray, your file uploaded!")
            }).then({(promise: Promise) -> () in
                // something here failed, so lets reject
                // the whole thing and fall through to fail()
                promise.reject()
                }).fail({
                    // alert the user that their file upload failed miserably
                    println("all is lost. accept defeat.")
                    }).done({
                        // we're done!
                        println("all done!")
                        })
    }
    
    func uploadFile() -> Promise {
        let p = Promise.defer()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let success = self.actualFileUpload()
            if !success {
                p.reject()
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                p.resolve()()
                })
            })
        return p
    }
    
    func actualFileUpload() -> Bool {
        return true
    }
    
}


