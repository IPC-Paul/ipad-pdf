//
//  InnerView.swift
//  PDF-Annotation
//
//  Created by Paul Benbrook on 6/8/16.
//  Copyright © 2016 Team IPC. All rights reserved.
//

import UIKit

class InnerView: UIView, UIDocumentInteractionControllerDelegate {
	
	documentInteractionController
	
	func documentInteractionControllerViewForPreview(controller: UIDocumentInteractionController) -> UIView? {
		return self
	}
	
	func LoadPDF (arrayVal : Int) {
		let urlPath = NSBundle.mainBundle().pathForResource(docNameArray[arrayVal], ofType: "pdf")
		let url:NSURL = NSURL.fileURLWithPath(urlPath!)
		let pdfRequest = NSURLRequest(URL: url)
		
		// pdfContainer.loadRequest(pdfRequest)
	}
	
}
