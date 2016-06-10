//
//  DrawView.swift
//  PDF-Annotation
//
//  Created by Paul Benbrook on 6/10/16.
//  Copyright © 2016 Team IPC. All rights reserved.
//

import UIKit

var drawingOpacity : CGFloat = 1.0

var red : CGFloat = 0.0
var green : CGFloat = 0.0
var blue : CGFloat = 0.0

var brushWidth : Int = 10
var brushOpacity : CGFloat = 1.0

var erasing = false

let colors : [String : (CGFloat, CGFloat, CGFloat)] = [
	"Black" : (0.0,0.0,0.0),
	"Grey" : (0.5,0.5,0.5),
	"Red" : (1.0,0.0,0.0),
	"Blue" : (0.0,0.0,1.0),
	"Yellow" : (1.0,1.0,0.0),
	"Green" : (0.0,1.0,0.0),
	"Orange" : (1.0,0.5,0.0),
	"Purple" : (1.0, 0.0, 1.0)
]

class DrawView: UIImageView {
	
	var pdfBox : UIImageView? // used to verify size constraints
	var drawSlave : UIImageView? // allows for transparency layer blending
	
	var lastPoint : CGPoint = CGPointZero
	
	var isStroke : Bool = false
	
	var undoHistory : [Int : [(CGPoint, CGPoint)]] = [0:[(CGPoint(),CGPoint())]]
	var currentIteration : Int = 0
	
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		isStroke = false
		
		currentIteration = undoHistory.count
		
		undoHistory[currentIteration] = [(CGPoint(),CGPoint())]
		
		if let touch = touches.first {
			lastPoint = touch.locationInView(self)
		}
	}
	
	func DrawLineFrom( fromPoint : CGPoint, toPoint : CGPoint) {
		
		// grab initial variables and set destination box for initial line
		UIGraphicsBeginImageContext( (window?.frame.size)! )
		let context = UIGraphicsGetCurrentContext()
		drawSlave!.image?.drawInRect(CGRect(x: 0, y: 0, width: (window?.frame.size.width)!, height: (window?.frame.size.height)!))
		
		// line building
		CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
		CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
		
		// brush size/opacity/color
		CGContextSetLineCap(context, .Round)
		CGContextSetLineWidth(context, CGFloat(brushWidth))
		CGContextSetRGBStrokeColor(context, red, green, blue, brushOpacity)
		CGContextSetBlendMode(context, .Saturation)
		
		// draw path
		CGContextStrokePath(context)
		
		if (!erasing) {
			// render line into slave image
			drawSlave?.image = UIGraphicsGetImageFromCurrentImageContext()
			drawSlave?.alpha = drawingOpacity
		} else {
			// erasure happens directly on stored image
			self.image = UIGraphicsGetImageFromCurrentImageContext()
		}
		UIGraphicsEndImageContext()
		
	}
	
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		
		
		isStroke = true
		
		if let touch = touches.first {
			
			let currentPoint = touch.locationInView(self)
			
			undoHistory[currentIteration]?.append((lastPoint,currentPoint))
			
			DrawLineFrom(lastPoint, toPoint: currentPoint)
			
			lastPoint = currentPoint
		}
	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		
		if !isStroke {
			DrawLineFrom(lastPoint, toPoint: lastPoint)
		}
		
		UpdateImage()
		
		drawSlave?.image = nil
		
	}
	
	func PageChanged(newImage : UIImage) {
		self.image = newImage
	}
	
	
	func UpdateImage() {
		
		/*
		self.image = UIImage()
		
		
		for i in 0 ..< undoHistory.count {
			for h in 0 ..< undoHistory[i]!.count {
				DrawLineFrom(undoHistory[i]
			}
		*/
			
			// merge images and reset slave
			UIGraphicsBeginImageContext(self.frame.size)
			self.image?.drawInRect(CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height), blendMode: .Normal, alpha: 1.0)
			drawSlave?.image?.drawInRect(CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height), blendMode: .Normal, alpha: 1.0)
			self.image = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			
		}
	}
	


func ChangeDefinedColor(color : String) {
	
	red = colors[color]!.0
	green = colors[color]!.1
	blue = colors[color]!.2
	
}

func DefineOwnColor (newRed : Float, newGreen : Float, newBlue : Float) {
	
	red = CGFloat(newRed)
	green = CGFloat(newGreen)
	blue = CGFloat(newBlue)
	
}