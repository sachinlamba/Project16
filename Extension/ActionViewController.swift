//
//  ActionViewController.swift
//  Extension
//
//  Created by Sachin Lamba on 30/06/16.
//  Copyright © 2016 LambaG. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    var pageTitle = ""
    var pageURL = ""
    
    @IBOutlet weak var script: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(done))
        
        if let inputItem = extensionContext!.inputItems.first as? NSExtensionItem {
          if let itemProvider = inputItem.attachments?.first as? NSItemProvider {
              itemProvider.loadItemForTypeIdentifier(kUTTypePropertyList as String, options: nil) { [unowned self] (dict, error) in
                            let itemDictionary = dict as! NSDictionary
                            let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as! NSDictionary
                            //print(javaScriptValues)
                            self.pageTitle = javaScriptValues["title"] as! String
                            self.pageURL = javaScriptValues["URL"] as! String
                
                            dispatch_async(dispatch_get_main_queue()) {
                                self.title = self.pageTitle
                        }
               }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        let item = NSExtensionItem()
        let webDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: ["custonJavaScript": script.text]]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        
        
        self.extensionContext!.completeRequestReturningItems(self.extensionContext!.inputItems, completionHandler: nil)
    }

}
