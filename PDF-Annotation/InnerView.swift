//
//  InnerView.swift
//  PDF-Annotation
//
//  Created by Paul Benbrook on 6/8/16.
//  Copyright © 2016 Team IPC. All rights reserved.
//

import UIKit
import CoreGraphics
import QuartzCore

class InnerView: UIView {
	
	
	
	/*

	CGPDFPageRef pdfPage = CGPDFDocumentGetPage(pdf,pageNumber);
	CGRect tmpRect = CGPDFPageGetBoxRect(pdfPage,kCGPDFMediaBox);
	CGRect rect = CGRectMake(tmpRect.origin.x,tmpRect.origin.y,tmpRect.size.width*scale,tmpRect.size.height*scale);
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context,0,rect.size.height);
	CGContextScaleCTM(context,scale,-scale);
	CGContextDrawPDFPage(context,pdfPage);
	UIImage* pdfImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	*/

}
