//
//  ViewController.swift
//  PDF-Annotation
//
//  Created by Paul Benbrook on 6/8/16.
//  Copyright © 2016 Team IPC. All rights reserved.
//

import UIKit
import CoreGraphics

var fileArray : [String] = []
var docNameArray : [String] = []
var innerURL : NSURL = NSURL(fileURLWithPath: "")

var currentDoc : String = ""
var currentPage : Int = 0

class ViewController: UIViewController {
	
	@IBOutlet var innerView: UIView!
	@IBOutlet var menuButton: UIBarButtonItem!
	@IBOutlet var imageBox: UIImageView!
	
	let fileManager = NSFileManager.defaultManager()
	var error: NSError?
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		LoadPDFList()
		
		currentDoc = docNameArray[0]
        
		LoadPDF()
	}
	
	func LoadPDFList() {
		
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
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
	var pageCount : Int = 0
	var currentPage = 1
	var pdf : CGPDFDocument?
	
	func LoadPDF () {
		
		innerURL = NSBundle.mainBundle().URLForResource(currentDoc, withExtension: "pdf")!
		pdf = CGPDFDocumentCreateWithURL(innerURL)!
		pageCount = CGPDFDocumentGetNumberOfPages(pdf)
		currentPage = 1
		
		LoadPage()
	}
	
	func ChangePage (newPage : Int) {
		currentPage = newPage
		LoadPage()
	}
	
	var thisFrame : CGRect = CGRectMake(0, 0, 0, 0)
	
	func LoadPage () {
		
		let thisPage : CGPDFPageRef = CGPDFDocumentGetPage(pdf, currentPage)!
		
        // CGContextDrawPDFPage(context, thisPage)
		
		thisFrame = CGPDFPageGetBoxRect(thisPage, .MediaBox)
		UIGraphicsBeginImageContext(CGSizeMake( thisFrame.width, thisFrame.height ))
		
		let ctx: CGContextRef = UIGraphicsGetCurrentContext()!
		
		CGContextSaveGState(ctx)
		CGContextTranslateCTM(ctx, 1.0, thisFrame.height)
		CGContextScaleCTM(ctx, 1.0, -1.0)
		CGContextSetGrayFillColor(ctx, 1.0, 1.0)
		CGContextFillRect(ctx, thisFrame)
		
		let pdfTransform: CGAffineTransform = CGPDFPageGetDrawingTransform(thisPage, .MediaBox, thisFrame, 0, true)
		CGContextConcatCTM(ctx, pdfTransform);
		CGContextSetInterpolationQuality(ctx, .High)
		CGContextSetRenderingIntent(ctx, .RenderingIntentDefault)
		CGContextDrawPDFPage(ctx, thisPage)
		
		let thumbnailImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
		CGContextRestoreGState(ctx)
		// var documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last!
		UIGraphicsEndImageContext()
		
        // let imagedata = UIImagePNGRepresentation(thumbnailImage)
		// imagedata!.writeToFile(documentsPath, atomically: true)
		
		imageBox.image = thumbnailImage
		
	}
	
}