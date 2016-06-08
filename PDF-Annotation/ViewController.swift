//
//  ViewController.swift
//  PDF-Annotation
//
//  Created by Paul Benbrook on 6/8/16.
//  Copyright © 2016 Team IPC. All rights reserved.
//

import UIKit

var fileArray : [String] = []
var docNameArray : [String] = []

class ViewController: UIViewController, NSXMLParserDelegate {
	
	@IBOutlet var docView: InnerView!
	
	let fileManager = NSFileManager.defaultManager()
	var error: NSError?
	
	override func viewDidLoad() {
		
		do {
			fileArray = try fileManager.contentsOfDirectoryAtPath(NSBundle.mainBundle().resourcePath!)
		} catch {
			print(error)
		}
		
		for i in 0 ..< fileArray.count {
			var fileName = fileArray[i].componentsSeparatedByString(".")
			if fileName.count > 1 {
				if fileName[1] == "pdf" {
					docNameArray.append(fileName[0])
				}
			}
		}
		
		docView.LoadPDF(0)
		
		print(docNameArray)
		
		super.viewDidLoad()
		
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
}