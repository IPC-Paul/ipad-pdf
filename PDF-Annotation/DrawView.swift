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

var drawingLine : Bool = false
var drawSquare : Bool = true

var filledShape : Bool = false
var shapeLayer : CAShapeLayer = CAShapeLayer()

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
	
	var startPoint : CGPoint = CGPointZero
	var lastPoint : CGPoint = CGPointZero
	var endPoint : CGPoint = CGPointZero
	
	var isStroke : Bool = false
	
	var undoHistory : [Int : [(CGPoint, CGPoint)]] = [0:[(CGPoint(),CGPoint())]]
	var currentIteration : Int = 0
	
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if !drawingLine {
			startPoint = (touches.first?.locationInView(self))!
		}
		
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
		
		EndDrawing()
		
		UIGraphicsEndImageContext()
		
	}
	
	func DrawShapeIn( fromPoint : CGPoint, toPoint : CGPoint) {
		
		drawSlave?.image = nil
		
		UIGraphicsBeginImageContext( (window?.frame.size)! )
		let context = UIGraphicsGetCurrentContext()
		drawSlave!.image?.drawInRect(CGRect(x: 0, y: 0, width: (window?.frame.size.width)!, height: (window?.frame.size.height)!))
		
		let thisWidth = toPoint.x - startPoint.x
		let thisHeight = toPoint.y - startPoint.y
		
		var beginPoint = startPoint
		
		if thisWidth < 0 && thisHeight < 0 {
			beginPoint = toPoint
		} else if thisHeight < 0 {
			beginPoint.y = startPoint.y + thisHeight
		} else if thisWidth < 0 {
			beginPoint.x = startPoint.x + thisWidth
		}
		
		if filledShape {
			CGContextSetFillColorWithColor(context, UIColor(colorLiteralRed: Float(red), green: Float(green), blue: Float(blue), alpha: Float(brushOpacity)).CGColor)
			CGContextAddRect(context, CGRectMake(beginPoint.x, beginPoint.y, abs(thisWidth), abs(thisHeight)))
		} else {
			CGContextAddRect(context, CGRectMake(beginPoint.x, beginPoint.y, abs(thisWidth), abs(thisHeight)))
			CGContextSetLineWidth(context, CGFloat(brushWidth))
			CGContextSetStrokeColorWithColor(context, UIColor(colorLiteralRed: Float(red), green: Float(green), blue: Float(blue), alpha: Float(brushOpacity)).CGColor)
			CGContextStrokePath(context)
		}
		
		CGContextFillPath(context)
		
		EndDrawing()
		
		UIGraphicsEndImageContext()
		
		/*
		shapeLayer = CAShapeLayer()
		
		let thisWidth = toPoint.x - startPoint.x
		let thisHeight = toPoint.y - startPoint.y
		
		var beginPoint = startPoint
		
		if thisWidth < 0 && thisHeight < 0 {
			beginPoint = toPoint
		} else if thisHeight < 0 {
			beginPoint.y = startPoint.y + thisHeight
		} else if thisWidth < 0 {
			beginPoint.x = startPoint.x + thisWidth
		}
		
		shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: beginPoint.x, y: beginPoint.y, width: abs(thisWidth), height: abs(thisHeight)), cornerRadius:  50).CGPath
		
		shapeLayer.fillColor = UIColor(colorLiteralRed: Float(red), green: Float(green), blue: Float(blue), alpha: Float(brushOpacity)).CGColor
		
		drawSlave?.layer.sublayers = [shapeLayer]
		*/
	}
	
	func EndDrawing () {
		if (!erasing) {
			// render line into slave image
			drawSlave?.image = UIGraphicsGetImageFromCurrentImageContext()
			drawSlave?.alpha = drawingOpacity
		} else {
			// erasure happens directly on stored image
			self.image = UIGraphicsGetImageFromCurrentImageContext()
		}
	}
	
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		
		
		isStroke = true
		
		if let touch = touches.first {
			
			let currentPoint = touch.locationInView(self)
			
			undoHistory[currentIteration]?.append((lastPoint,currentPoint))
			
			if drawingLine {
				DrawLineFrom(lastPoint, toPoint: currentPoint)
			} else {
				DrawShapeIn(lastPoint, toPoint: currentPoint)
			}
			lastPoint = currentPoint
		}
	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		
		if !isStroke {
			DrawLineFrom(lastPoint, toPoint: lastPoint)
		}
		
		if !drawingLine {
			// EndDrawing()
		}
		
		UpdateImage()
		
		drawSlave?.image = nil
		// drawSlave?.layer.sublayers = []
		
	}
	
	func PageChanged(newImage : UIImage) {
		layer.sublayers?.removeAll()
		drawSlave?.layer.sublayers?.removeAll()
		
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