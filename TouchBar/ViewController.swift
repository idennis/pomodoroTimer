//
//  ViewController.swift
//  TouchBar
//
//  Created by Chris Ricker on 10/28/16.
//  Copyright © 2016 Ray Wenderlich. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var nameField: NSTextField!
    
    // Setting up the timer bar UI
    let pomodoroTimerBarView = NSView()
    var timerBarContainer:CAShapeLayer!
    var timerBar:CAShapeLayer!

    // Setting up timer
    var timer:Timer? = nil
    var progressCounter:Float = 0
    let duration:Float = 10.0

    var timeRemaining = 10.0
    var totalTime = 10.0

    
    var progress: Float = 0 {
        willSet(newValue)
        {
            //newValue is the same as progress (aka the percentage of progress til countdown timer is complete).
            resizeTimerBar(invertedProgressPercentage: CGFloat(100.00 - newValue), path: self.timerBar.path!, shapeLayer: self.timerBar!)
            print("resize!")
            print("newValue: ", newValue)
        }
    }
    
    @objc var visited = 0
    @objc var rating = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(OSX 10.12.2, *) {
            nameField.isAutomaticTextCompletionEnabled = false
        }
    }
    
    @IBAction func save(_ sender: Any) {
        willChangeValue(forKey: "rating")
        willChangeValue(forKey: "visited")
        rating = 0
        visited = 0
        nameField.stringValue = ""
        didChangeValue(forKey: "rating")
        didChangeValue(forKey: "visited")
    }
    
    @IBAction func changevisitedAmount(_ sender: NSSegmentedControl) {
        willChangeValue(forKey: "visited")
        switch sender.selectedSegment {
        case 0:
            if visited > 0 {
                visited -= 1
            }
        case 1:
            visited += 1
        default:
            break
        }
        didChangeValue(forKey: "visited")
    }
    
    @IBAction func changeRating(_ sender: NSSegmentedControl) {
        willChangeValue(forKey: "rating")
        switch sender.selectedSegment {
        case 0:
            if rating > 0 {
                rating -= 1
            }
        case 1:
            if rating < 4 {
                rating += 1
            }
        default:
            break
        }
        didChangeValue(forKey: "rating")
    }
    
    
    // MARK: - Start Countdown
    @objc public func startCountdown() {
        if (timeRemaining <= 0) {self.timer?.invalidate()}
        else {
            timeRemaining -= 1
            let completionPercentage = (((Float(totalTime) - Float(timeRemaining))/Float(totalTime)) * 100)
            self.progress = completionPercentage
            print("timeRemaining", timeRemaining)
            print("completionPercentage", completionPercentage)
//            progressView.setProgress(Float(timeRemaining)/Float(totalTime), animated: false)
            
    //        let minutesLeft = Int(timeRemaining) / 60 % 60
    //        let secondsLeft = Int(timeRemaining) % 60
            
            
            
    //        manageTimerEnd(seconds: timeRemaining)
    //        isOnBreak = true
        }
    }
}

// MARK: - Pomodoro Timer Rectangle
func createBar(x: Double, y: Double, width: Double, height: Double, xRadius: CGFloat, yRadius: CGFloat, fillColor: CGColor) -> CAShapeLayer {
    let barShapeLayer = CAShapeLayer()
    // LED shape
    let rectangle = CGRect(x: x, y: y, width: width, height: height)
    barShapeLayer.path = NSBezierPath(roundedRect: rectangle, xRadius: xRadius, yRadius: yRadius).cgPath
    barShapeLayer.opacity = 0
    barShapeLayer.masksToBounds = false
    barShapeLayer.fillColor = fillColor
    
    return barShapeLayer
}


func resizeTimerBar(invertedProgressPercentage: CGFloat, path: CGPath, shapeLayer: CAShapeLayer) {
//    let boundingBox = path.boundingBox
    let newBox = CGRect(x: 0, y: shapeLayer.bounds.minY, width: invertedProgressPercentage/100*shapeLayer.bounds.width, height: shapeLayer.bounds.height)
    let newPath = CGPath(roundedRect: newBox, cornerWidth: 5.0, cornerHeight: 5.0, transform: nil)
    var layerAnimation = CABasicAnimation(keyPath: "path")
    layerAnimation.fromValue = shapeLayer.path
    layerAnimation.toValue = newPath
    shapeLayer.path = newPath
}

// MARK: - Scrubber DataSource & Delegate

@available(OSX 10.12.2, *)
extension ViewController: NSScrubberDataSource, NSScrubberDelegate {
    
    func numberOfItems(for scrubber: NSScrubber) -> Int {
        return 5
    }
    
    func scrubber(_ scrubber: NSScrubber, viewForItemAt index: Int) -> NSScrubberItemView {
        let itemView = scrubber.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "RatingScrubberItemIdentifier"), owner: nil) as! NSScrubberTextItemView
        itemView.textField.stringValue = String(index)
        return itemView
    }
    
    func scrubber(_ scrubber: NSScrubber, didSelectItemAt index: Int) {
        willChangeValue(forKey: "rating")
        rating = index
        didChangeValue(forKey: "rating")
    }
    
}

// MARK: - TouchBar Delegate
@available(OSX 10.12.2, *)
extension ViewController: NSTouchBarDelegate {
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .travelBar
        // Always implement the list of items in a Touch Bar via an array.
        touchBar.defaultItemIdentifiers = [.appLabel, .timerBar]
        touchBar.customizationAllowedItemIdentifiers = [.infoLabelItem]
        return touchBar
    }
    
    @available(OSX 10.12.2, *)
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        switch identifier {
            
        case NSTouchBarItem.Identifier.appLabel:
            let customViewItem = NSCustomTouchBarItem(identifier: identifier)
            customViewItem.view = NSTextField(labelWithString: "🍅")
            return customViewItem
            
            
        case NSTouchBarItem.Identifier.timerBar:
            
            let customViewItem = NSCustomTouchBarItem(identifier: identifier)
            self.timerBarContainer = CAShapeLayer()
            
            // MARK: Create Timer Bar Shape Layer
            self.pomodoroTimerBarView.wantsLayer = true
            self.pomodoroTimerBarView.bounds = NSRect(x: 12.5, y: 0.0, width: 500, height: 30)
            // Create bg bar
            var fillColor = CGColor.init(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0)
            let bgBar = createBar(x: 12.5, y: 0.0, width: 500, height: 30, xRadius: 5.0, yRadius: 5.0, fillColor: fillColor)
            bgBar.opacity = 1.0
            
            // Create timer bar
            fillColor = NSColor.systemRed.cgColor
            self.timerBar = createBar(x: 12.5, y: 0.0, width: 480, height: 30, xRadius: 5.0, yRadius: 5.0, fillColor: fillColor)
            self.timerBar.frame = CGRect(x: 0, y: 0, width: self.timerBar.path!.boundingBox.width, height: 30)
            self.timerBar.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            self.timerBar.opacity = 1.0
            
            
            if(self.timer == nil) {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.startCountdown), userInfo: nil, repeats: true)
            }
            
            
            
            self.timerBarContainer.addSublayer(bgBar)
            self.timerBarContainer.addSublayer(self.timerBar)
            
            pomodoroTimerBarView.layer?.addSublayer(self.timerBarContainer)
            
            
            
            
            
            // MARK: Create Text Label for Timer
            let myAttribute = [
                NSAttributedString.Key.font: NSFont.systemFont(ofSize: 0),
                NSAttributedString.Key.foregroundColor: NSColor.white
            ]
            
            let timerText = NSAttributedString(string: "Time Remaining: ", attributes: myAttribute )
            let myTextLayer = CATextLayer()
            myTextLayer.string = timerText
            myTextLayer.frame = CGRect(x: timerBar.path!.boundingBox.origin.x + 12.5, y: (timerBar.path!.boundingBox.height - myTextLayer.fontSize) - 0.5, width: timerBar.path!.boundingBox.width, height: timerBar.path!.boundingBox.height)
            myTextLayer.opacity = 1.0
            myTextLayer.alignmentMode = CATextLayerAlignmentMode.natural
            myTextLayer.contentsScale = (NSScreen.main?.backingScaleFactor)!
            self.pomodoroTimerBarView.layer?.addSublayer(myTextLayer)
            
            
            customViewItem.view = pomodoroTimerBarView
            
            return customViewItem
            
            
            
            
            
        case NSTouchBarItem.Identifier.ratingScrubber:
            // 2
            let scrubberItem = NSCustomTouchBarItem(identifier: identifier)
            let scrubber = NSScrubber()
            scrubber.scrubberLayout = NSScrubberFlowLayout()
            scrubber.register(NSScrubberTextItemView.self, forItemIdentifier: NSUserInterfaceItemIdentifier(rawValue: "RatingScrubberItemIdentifier"))
            scrubber.mode = .fixed
            scrubber.selectionBackgroundStyle = .roundedBackground
            scrubber.delegate = self
            scrubber.dataSource = self
            scrubberItem.view = scrubber
            scrubber.bind(NSBindingName(rawValue: "selectedIndex"), to: self, withKeyPath: #keyPath(rating), options: nil)
            return scrubberItem
        case NSTouchBarItem.Identifier.visitedLabelItem:
            // 1
            let customViewItem = NSCustomTouchBarItem(identifier: identifier)
            customViewItem.view = NSTextField(labelWithString: "Times Visited")
            return customViewItem
        case NSTouchBarItem.Identifier.visitedItem:
            // 2
            let customViewItem = NSCustomTouchBarItem(identifier: identifier)
            customViewItem.view = NSTextField(labelWithString: "--")
            customViewItem.view.bind(NSBindingName(rawValue: "value"), to: self, withKeyPath: #keyPath(visited), options: nil)
            return customViewItem
        case NSTouchBarItem.Identifier.visitSegmentedItem:
            // 3
            let customActionItem = NSCustomTouchBarItem(identifier: identifier)
            let segmentedControl = NSSegmentedControl(images: [NSImage(named: NSImage.removeTemplateName)!, NSImage(named: NSImage.addTemplateName)!], trackingMode: .momentary, target: self, action: #selector(changevisitedAmount(_:)))
            segmentedControl.setWidth(40, forSegment: 0)
            segmentedControl.setWidth(40, forSegment: 1)
            customActionItem.view = segmentedControl
            return customActionItem
        case NSTouchBarItem.Identifier.saveItem:
            let saveItem = NSCustomTouchBarItem(identifier: identifier)
            let button = NSButton(title: "Save", target: self, action: #selector(save(_:)))
            button.bezelColor = NSColor(red:0.35, green:0.61, blue:0.35, alpha:1.00)
            saveItem.view = button
            return saveItem
            
        default:
            return nil
        }
    }
}


extension NSBezierPath {
    
    public var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)
        
        for i in 0 ..< self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)
            switch type {
            case .moveTo:
                path.move(to: points[0])
            case .lineTo:
                path.addLine(to: points[0])
            case .curveTo:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
            case .closePath:
                path.closeSubpath()
            }
        }
        
        return path
    }
}
