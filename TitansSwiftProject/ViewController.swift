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
        testOddEven()
        loadJSONFile()
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
    
    func loadJSONFile() -> Void{
        var validJSONData:NSData!

        validJSONData = NSData(contentsOfFile : NSBundle(forClass: ViewController.self).pathForResource("Valid", ofType: "JSON"))
        let json = JSONValue(validJSONData)
        
        let stringValue = json["title"].string
        let numberValue = json["id"].number
        let boolValue = json["user"]["site_admin"].bool
        let nullValue = json["closed_by"]
        let arrayValue = json["labels"].array
        let objectValue = json["user"].object

        println("the resul is \(stringValue),\(boolValue)")
        
        switch json["user"]{
        case .JString(let stringValue):
            let id = stringValue.toInt()
        case .JNumber(let numberValue):
            let id = numberValue.integerValue
        case .JObject(let ObjectValue):
            let id = objectValue
        default:
            println("ooops!!! JSON Data is Unexpected or Broken")

        
        var customerData:NSData!
        
        //Case sensitive
        customerData = NSData(contentsOfFile : NSBundle(forClass: ViewController.self).pathForResource("customers", ofType: "JSON"))
        let customer = JSONValue(customerData)
        let url = customer["url"].string
        let orders = customer["customers"].array
        let testOrder = customer["customers"][2]["orders"]["order"][0]["total"].string

        println("tootal resul is \(url),testOrder is \(testOrder)")

        let handleErrorMessage = JSONValue(customerData)["customers"].array
        
      
        
        if handleErrorMessage{
            println("tootal resul is \(url),order is \(orders)")

        }
//        else{
//            println(handleErrorMessage)
//         
//            switch handleErrorMessage{
//                
//            case .JInvalid(let error):
//                println()
//                
//            default :
//                println()
//            }
//        }
    
    }
    
}
    
    func testOddEven()
    {
        let numbers = (100...150)
            .map { n -> (Number:Int, OddEven:String) in
                (n, n % 2 == 1 ? "odd" : "even")
        }
        
        for n in numbers {
            println("The number \(n.Number) is \(n.OddEven).")
        }
    }

}
