//
//  ViewController.swift
//  PDF-Annotation
//
//  Created by Paul Benbrook on 6/8/16.
//  Copyright © 2016 Team IPC. All rights reserved.
//

import UIKit
import CoreGraphics

var docNameArray : [String] = []
var fileArray : [String] = []
var previewArray : [UIImage] = []
var annotationArray : [Int : UIImage] = [:]
var innerURL : NSURL = NSURL(fileURLWithPath: "")

var currentDoc : String = ""
var currentPage : Int = 0

class ViewController: UIViewController {
	
	@IBOutlet var drawView: DrawView!
	@IBOutlet var drawSlave: UIImageView!
	
	@IBOutlet var menuButton: UIBarButtonItem!
	@IBOutlet var imageBox: UIImageView!
	
	var pageCount : Int = 0
	var currentPage = 0
	var pdf : CGPDFDocument?
	
	let fileManager = NSFileManager.defaultManager()
	var error: NSError?
	
	var thisFrame : CGRect = CGRectMake(0, 0, 0, 0)
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		drawView.pdfBox = imageBox
		drawView.drawSlave = drawSlave
		
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
	
	func LoadPDF () {
		
		innerURL = NSBundle.mainBundle().URLForResource(currentDoc, withExtension: "pdf")!
		pdf = CGPDFDocumentCreateWithURL(innerURL)!
		pageCount = CGPDFDocumentGetNumberOfPages(pdf)
		currentPage = 1
		
		LoadPages()
	}
	
	func LoadPages () {
		
		for i in 0 ..< pageCount {
			let thisPage : CGPDFPageRef = CGPDFDocumentGetPage(pdf, i + 1)!
			
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
			UIGraphicsEndImageContext()
			
			previewArray.append(thumbnailImage)
		}
		
		annotationArray = [:]
		annotationArray[0] = UIImage()
		
		ChangePage(0)
		
	}
	
	func ChangePage (newPage : Int) {
		
		annotationArray[currentPage] = drawView.image
		currentPage = newPage
		
		imageBox.image = previewArray[newPage]
		
		if annotationArray[newPage] == nil {
			annotationArray[newPage] = UIImage()
		}
		
		drawView.PageChanged(annotationArray[newPage]!)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
}