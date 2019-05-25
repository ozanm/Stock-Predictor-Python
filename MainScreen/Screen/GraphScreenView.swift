import AppKit

class GraphViewController : NSViewController {

  // x-coordinates go for the day
  // y-coordinates go for the amount

  var currentStock : StockStructer!

  var futureData : [Any]!

  var grid : [[Any]] = []
  var graphData : [NSDictionary]!
  var info : NSView!

  let graph : NSView = NSView()
  var x_bars : [NSView] = []
  var y_bars : [NSView] = []

  let stockStatus : NSView = NSView()
  let closeBtn : NSButton = NSButton()

  override func loadView() {
    self.view = NSView(frame: NSScreen.main!.visibleFrame)
    self.view.wantsLayer = true
    self.view.layer!.backgroundColor = NSColor.black.cgColor
    self.view.layer!.cornerRadius = 35
    self.view.layer!.maskedCorners = [.layerMaxXMaxYCorner]

    self.view.autoresizesSubviews = true
  }

  override func viewDidLoad() {
    self.setStock()
    self.renderCloseBtn()
    self.constructStockStatus()
    self.displayAccuracy()
  }

  func setStock() {
    currentStock = StockStructer.mainStock
    StockStructer.mainStock = nil

    Excecute.execCommand(command: "/usr/local/bin/wget", args: ["https://www.dropbox.com/s/67anjgkcbik3hkp/pull_intraday_data.py"])
    Excecute.execCommand(command: "/Library/Frameworks/Python.framework/Versions/3.7/bin/python3", args: [DIRECTORY + "/pull_intraday_data.py", currentStock.getSymbol()])
    Excecute.execCommand(command: "/bin/rm", args: [DIRECTORY + "/pull_intraday_data.py"])
    Excecute.execCommand(command: "/bin/rm", args: [DIRECTORY + "/wget-log"])

    graphData = (JSON.readJSONFromFile(fileName: "../../Data/IntraDay/intraday_data") as? [NSDictionary])!
  }

  func renderCloseBtn() {
    closeBtn.frame = CGRect(x: 20, y: self.view.frame.size.height, width: 50, height: 50)
    closeBtn.isBordered = false
    closeBtn.isTransparent = false
    closeBtn.action = #selector(self.exit(_:))
    closeBtn.title = ""
    closeBtn.wantsLayer = true
    closeBtn.layer!.backgroundColor = NSColor.darkGray.cgColor
    closeBtn.layer!.cornerRadius = 20
    closeBtn.alphaValue = 0.0
    self.view.addSubview(closeBtn)

    let icon = NSImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
    icon.load(url: URL(string: "https://i.imgur.com/dXsQi65.png")!)
    closeBtn.addSubview(icon)

    NSAnimationContext.beginGrouping()
    NSAnimationContext.current.duration = 1.0
    closeBtn.animator().frame.origin.y -= 70
    closeBtn.animator().alphaValue = 1.0
    NSAnimationContext.endGrouping()
  }

  @objc func exit(_ sender: NSButton!) {
    self.view.window!.close()
  }

  func constructStockStatus() {
    stockStatus.frame = CGRect(x: 0, y: self.view.frame.size.height - 100, width: self.view.frame.size.width, height: 100)
    stockStatus.alphaValue = 0.0
    self.view.addSubview(stockStatus)
    let underline = NSView(frame: CGRect(x: stockStatus.frame.size.width / 2, y: 1, width: 0, height: 1))
    underline.wantsLayer = true
    underline.layer!.backgroundColor = NSColor.darkGray.cgColor
    stockStatus.addSubview(underline)
    let ttl = NSTextField(frame: CGRect(x: 80, y: 20, width: currentStock.getSymbol().width(withConstrainedHeight: 60, font: NSFont.systemFont(ofSize: 45)) + 50, height: 60))
    ttl.stringValue = currentStock.getSymbol()
    ttl.isBezeled = false
    ttl.isEditable = false
    ttl.drawsBackground = false
    ttl.font = NSFont.systemFont(ofSize: 45)
    ttl.textColor = NSColor.white
    stockStatus.addSubview(ttl)
    let companyName = NSTextField(frame: CGRect(x: 80, y: 0, width: currentStock.getFullName().width(withConstrainedHeight: 30, font: NSFont.systemFont(ofSize: 20)) + 50, height: 30))
    companyName.stringValue = currentStock.getFullName()
    companyName.isBezeled = false
    companyName.isEditable = false
    companyName.drawsBackground = false
    companyName.font = NSFont.systemFont(ofSize: 20)
    companyName.textColor = NSColor.white
    stockStatus.addSubview(companyName)
    let regionMarket = NSTextField(frame: CGRect(x: ttl.frame.origin.x + ttl.frame.size.width - 40, y: 35, width: currentStock.getRegionMarket().width(withConstrainedHeight: 30, font: NSFont.systemFont(ofSize: 25)) + 50, height: 30))
    regionMarket.stringValue = currentStock.getRegionMarket()
    regionMarket.isBezeled = false
    regionMarket.isEditable = false
    regionMarket.drawsBackground = false
    regionMarket.font = NSFont.systemFont(ofSize: 25)
    regionMarket.textColor = NSColor.lightGray
    stockStatus.addSubview(regionMarket)
    let currentPrice = NSTextField(frame: CGRect(x: 0, y: 20, width: String(format: "$%.2f", currentStock.getCurrentPrice()).width(withConstrainedHeight: 60, font: NSFont.systemFont(ofSize: 45)) + 50, height: 60))
    currentPrice.frame.origin.x = self.view.frame.size.width - currentPrice.frame.size.width + 10
    currentPrice.stringValue = String(format: "$%.2f", currentStock.getCurrentPrice())
    currentPrice.isBezeled = false
    currentPrice.isEditable = false
    currentPrice.drawsBackground = false
    currentPrice.font = NSFont.systemFont(ofSize: 45)
    currentPrice.textColor = NSColor.darkGray
    stockStatus.addSubview(currentPrice)
    let percentChange = NSTextField(frame: CGRect(x: 0, y: 5, width: 0, height: 30))
    percentChange.isBezeled = false
    percentChange.isEditable = false
    percentChange.drawsBackground = false
    percentChange.font = NSFont.systemFont(ofSize: 20)
    if currentStock.getPercentChange() > 0 {
      percentChange.stringValue = "+"
      percentChange.textColor = NSColor(red: (66 / 255), green: (244 / 255), blue: (66 / 255), alpha: 1)
    } else {
      percentChange.textColor = NSColor(red: (244 / 255), green: (66 / 255), blue: (66 / 255), alpha: 1)
    }
    percentChange.stringValue += String(format: "%.2f%%", currentStock.getPercentChange())
    percentChange.frame.origin.x = self.view.frame.size.width - 40 - percentChange.stringValue.width(withConstrainedHeight: 30, font: NSFont.systemFont(ofSize: 20))
    percentChange.frame.size.width = percentChange.stringValue.width(withConstrainedHeight: 30, font: NSFont.systemFont(ofSize: 20)) + 25
    stockStatus.addSubview(percentChange)
    let priceChange = NSTextField(frame: CGRect(x: 0, y: 5, width: 0, height: 30))
    priceChange.isBezeled = false
    priceChange.isEditable = false
    priceChange.drawsBackground = false
    priceChange.font = NSFont.systemFont(ofSize: 20)
    if currentStock.getPriceChange() > 0 {
      priceChange.stringValue = "+"
      priceChange.textColor = NSColor(red: (66 / 255), green: (244 / 255), blue: (66 / 255), alpha: 1)
    } else {
      priceChange.textColor = NSColor(red: (244 / 255), green: (66 / 255), blue: (66 / 255), alpha: 1)
    }
    priceChange.stringValue += String(format: "%.2f", currentStock.getPriceChange())
    priceChange.frame.origin.x = percentChange.frame.origin.x - priceChange.stringValue.width(withConstrainedHeight: 30, font: NSFont.systemFont(ofSize: 20)) - 5
    priceChange.frame.size.width = priceChange.stringValue.width(withConstrainedHeight: 30, font: NSFont.systemFont(ofSize: 20)) + 25
    stockStatus.addSubview(priceChange)
    NSAnimationContext.beginGrouping()
    NSAnimationContext.current.duration = 1.0
    stockStatus.animator().alphaValue = 1.0
    underline.animator().frame.origin.x = 20
    underline.animator().frame.size.width = stockStatus.frame.size.width - 40
    NSAnimationContext.endGrouping()
  }

  func displayGraph() {
    graph.frame = CGRect(x: 20, y: 20, width: self.view.frame.size.width - 40, height: self.view.frame.size.height - 140)
    graph.addTrackingArea(NSTrackingArea(rect: graph.bounds, options: [NSTrackingArea.Options.activeInKeyWindow, NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.mouseMoved], owner: self, userInfo: nil))
    graph.wantsLayer = true
    self.view.addSubview(graph)

    x_bars = self.createXBars()
    y_bars = self.createYBars()

    let x_axis = NSView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
    x_axis.wantsLayer = true
    x_axis.layer!.backgroundColor = NSColor.white.cgColor
    graph.addSubview(x_axis)

    let y_axis = NSView(frame: CGRect(x: 0, y: 0, width: 1, height: 0))
    y_axis.wantsLayer = true
    y_axis.layer!.backgroundColor = NSColor.white.cgColor
    graph.addSubview(y_axis)

    NSAnimationContext.beginGrouping()
    NSAnimationContext.current.duration = 1.0
    x_axis.animator().frame.size.width = graph.frame.size.width
    y_axis.animator().frame.size.height = graph.frame.size.height
    NSAnimationContext.endGrouping()

    let x_pos = getBarXPos()
    for i in 1...x_pos.count {
      let divider = NSView(frame: CGRect(x: x_pos[i - 1] - 1, y: 0, width: 1, height: 0))
      divider.wantsLayer = true
      divider.layer!.backgroundColor = NSColor.darkGray.cgColor
      graph.addSubview(divider)

      NSAnimationContext.beginGrouping()
      NSAnimationContext.current.duration = 1.0
      divider.animator().frame.size.height = graph.frame.size.height
      NSAnimationContext.endGrouping()
    }

    let y_pos = getBarYPos()
    for i in 1...y_pos.count {
      let divider = NSView(frame: CGRect(x: 0, y: y_pos[i - 1] - 1, width: 0, height: 1))
      divider.wantsLayer = true
      divider.layer!.backgroundColor = NSColor.darkGray.cgColor
      graph.addSubview(divider)

      NSAnimationContext.beginGrouping()
      NSAnimationContext.current.duration = 1.0
      divider.animator().frame.size.width = graph.frame.size.width
      NSAnimationContext.endGrouping()
    }
  }

  func setUpCoordinates() {
    // Setup for the x-coordinates system of the graph.
    // First we get the number of days in current month then create the same number of items in the list and fill that with a value of
    // (graph's length / number of days in current month) * amount of items in list so far
    for i in 0...Date.getNumberOfMonths() {
      grid.append([Point(x: (Int(graph.frame.size.width) / Date.getNumberOfMonths()) * i, y: 0)])
    }

    // Then we shift through the values and append the right value for the right index
    for i in 0..<graphData.count {
      let index = Int(String((graphData[i]["6. time"] as? String)!.characters.suffix(2)))!
      grid[index - 1].append(graphData[i])
    }

    // Setup for the y-coordinates system of the graph.
    // First we get the biggest value in the list and set that as the biggest point
    var y_pos = ["Min": Double((graphData[0]["4. close"] as? String)!)!, "Max": Double((graphData[0]["4. close"] as? String)!)!]
    for i in 1..<graphData.count {
      if Double((graphData[i]["4. close"] as? String)!)! > y_pos["Max"]! {
        y_pos["Max"] = Double((graphData[i]["4. close"] as? String)!)!
      } else if Double((graphData[i]["4. close"] as? String)!)! < y_pos["Min"]! {
        y_pos["Min"] = Double((graphData[i]["4. close"] as? String)!)!
      }
    }
    // Then we create a good space for every possible value. This is frome ratios
    // The formula is |the largest y position - the ssmallest y position|
    var count : Int = 0
    var scaledAble : Bool = true
    for i in 0..<grid.count {
      if grid[i].count > 1 {
        (grid[i][0] as? Point)!.y = Int(Double(((grid[i][1] as? NSDictionary)!["4. close"] as? String)!)! - y_pos["Min"]!)
        if (grid[i][0] as? Point)!.y > Int(self.graph.frame.size.height / 2) {
          scaledAble = false
        }
      count += 1
      }
    }

    if scaledAble {
      for i in 0..<grid.count {
        (grid[i][0] as? Point)!.y += Int(self.graph.frame.size.height / 2)
      }
    }

    // Implementing the Forecasted Data
    var probability = 0.7
    if (grid[count - 1][0] as? Point)!.y > Int(graph.frame.size.height / 2) {
      probability = 0.4
    }

    futureData = [Float.random(in: 0...1) < Float(probability), count + 5]
  }

  override func mouseEntered(with event: NSEvent) {
    NSCursor.hide()

    let mouseLocation = event.locationInWindow.convert(to: graph.bounds)

    for bar in x_bars {
      bar.frame.origin.y = mouseLocation.y - 20
      let temp = bar.frame.origin.x
      bar.frame.origin.x = event.locationInWindow.x
      NSAnimationContext.beginGrouping()
      NSAnimationContext.current.duration = 0.5
      bar.animator().alphaValue = 1.0
      bar.animator().frame.origin.x = temp
      NSAnimationContext.endGrouping()
      graph.addSubview(bar)
    }

    for bar in y_bars {
      bar.frame.origin.x = mouseLocation.x - 20
      let temp = bar.frame.origin.y
      bar.frame.origin.y = event.locationInWindow.y
      NSAnimationContext.beginGrouping()
      NSAnimationContext.current.duration = 0.5
      bar.animator().alphaValue = 1.0
      bar.animator().frame.origin.y = temp
      NSAnimationContext.endGrouping()
      graph.addSubview(bar)
    }
  }

  override func mouseExited(with event: NSEvent) {
    NSCursor.unhide()

    for bar in x_bars {
      bar.removeFromSuperview()
    }

    for bar in y_bars {
      bar.removeFromSuperview()
    }
  }

  override func mouseMoved(with event: NSEvent) {

    let mouseLocation = event.locationInWindow.convert(to: graph.bounds)

    for bar in x_bars {
      bar.alphaValue = 1.0
      bar.frame.origin.y = mouseLocation.y - 20
    }

    for bar in y_bars {
      bar.alphaValue = 1.0
      bar.frame.origin.x = mouseLocation.x - 20
    }

    for position in grid {
      if abs(((position[0] as! Point).x as Int) - Int(mouseLocation.x)) < 10 {
        if position.count > 1 {
          NSAnimationContext.beginGrouping()
          NSAnimationContext.current.duration = 0.5
          info.animator().frame.origin = mouseLocation
          NSAnimationContext.endGrouping()

          var types = ["1. open", "2. high", "3. low", "4. close", "5. volume", "6. time"]
          for (key, value) in (position[1] as! NSDictionary) {
            var count = 0
            for type in types {
              if (key as! String) == type {
                types[count] += ": " + (value as! String)
              }

              count += 1
            }
          }

          var count = 0
          for lbl in info.subviews {
            if count < 4 {
              types[count] = types[count].substring(to: types[count].index(types[count].endIndex, offsetBy: -2))
            }
            (lbl as? NSTextField)!.stringValue = types[count]
            count += 1
          }
        } else {
          NSAnimationContext.beginGrouping()
          NSAnimationContext.current.duration = 0.5
          info.animator().frame.origin = NSPoint(x: -160, y: -190)
          NSAnimationContext.endGrouping()
        }
      }
    }
  }

  func renderGraphData() {
    let figure = NSBezierPath() // container for line(s)
    var was_last = false
    for i in 1..<grid.count {
      if grid[i].count > 1 {
        var dist = 1
        if was_last {
          dist = 3
        }
        figure.move(to: NSPoint(x: (grid[i - dist][0] as? Point)!.x, y: (grid[i - dist][0] as? Point)!.y)) // start point
        figure.line(to: NSPoint(x: (grid[i][0] as? Point)!.x, y: (grid[i][0] as? Point)!.y)) // destination
        was_last = false

        let point = NSView(frame: CGRect(x: (grid[i][0] as? Point)!.x - 10, y: (grid[i][0] as? Point)!.y - 10, width: 20, height: 20))
        point.wantsLayer = true
        point.layer!.borderWidth = 2
        point.layer!.borderColor = NSColor.white.cgColor
        point.layer!.cornerRadius = 10
        point.alphaValue = 0.0
        graph.addSubview(point)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.25) {
          NSAnimationContext.beginGrouping()
          NSAnimationContext.current.duration = 1.0
          point.animator().alphaValue = 1.0
          NSAnimationContext.endGrouping()
        }
      } else {
        was_last = true
      }
    }

    info = NSView(frame: CGRect(x: -190, y: -190, width: 190, height: 190))
    info.wantsLayer = true
    info.layer!.cornerRadius = 10
    info.layer!.backgroundColor = NSColor(red: (66 / 255), green: (244 / 255), blue: (178 / 255), alpha: 1).cgColor
    graph.addSubview(info)

    for i in 0..<6 {
      let lbl = NSTextField(frame: CGRect(x: 16, y: (i * 30) + 10, width: 160, height: 20))
      lbl.drawsBackground = false
      lbl.isEditable = false
      lbl.isBezeled = false
      lbl.textColor = NSColor.white
      lbl.font = NSFont.systemFont(ofSize: 15)

      info.addSubview(lbl)
    }

    let shapeLayer = CAShapeLayer()
    shapeLayer.path = figure.cgPath
    shapeLayer.lineWidth = 10
    shapeLayer.strokeColor = NSColor.white.cgColor
    shapeLayer.lineCap = .round
    graph.layer!.addSublayer(shapeLayer)

    let gradient = CAGradientLayer()
    gradient.frame = figure.bounds
    gradient.bounds = figure.bounds
    gradient.colors = [NSColor(red: (66 / 255), green: (244 / 255), blue: (66 / 255), alpha: 1).cgColor, NSColor(red: (66 / 255), green: (66 / 255), blue: (244 / 255), alpha: 1).cgColor]
    let shapeMask = CAShapeLayer()
    shapeMask.path = figure.cgPath
    gradient.mask = shapeLayer

    graph.layer!.addSublayer(gradient)

    let animation = CABasicAnimation(keyPath: "strokeEnd")
    /* set up animation */
    animation.fromValue = 0.0
    animation.toValue = 1.0
    animation.duration = 2.5

    shapeLayer.add(animation, forKey: "currentData")
    gradient.add(animation, forKey: "currentData")

    DispatchQueue.main.asyncAfter(deadline: .now() + 2.25) {
      let futureDataLine = NSBezierPath()
      futureDataLine.move(to: NSPoint(x: (self.grid[self.futureData[1] as! Int][0] as! Point).x, y: (self.grid[self.futureData[1] as! Int][0] as! Point).y))
      if self.futureData[0] as! Bool {
        futureDataLine.line(to: NSPoint(x: self.graph.frame.size.width, y: self.graph.frame.size.height))
      } else {
        futureDataLine.line(to: NSPoint(x: self.graph.frame.size.width, y: 0))
      }

      let shapeLayer = CAShapeLayer()
      shapeLayer.path = futureDataLine.cgPath
      shapeLayer.lineWidth = CGFloat(Int.random(in: 100...400))
      shapeLayer.strokeColor = NSColor.white.cgColor
      shapeLayer.lineCap = .round
      self.graph.layer!.addSublayer(shapeLayer)

      let gradient = CAGradientLayer()
      gradient.frame = futureDataLine.bounds
      gradient.bounds = futureDataLine.bounds
      gradient.colors = [NSColor(red: (240 / 255), green: (230 / 255), blue: (122 / 255), alpha: 1).cgColor, NSColor(red: (221 / 255), green: (129 / 255), blue: (104 / 255), alpha: 1).cgColor]
      gradient.mask = shapeLayer

      self.graph.layer!.addSublayer(gradient)

      let animation = CABasicAnimation(keyPath: "strokeEnd")
      /* set up animation */
      animation.fromValue = 0.0
      animation.toValue = 1.0
      animation.duration = 2.5

      shapeLayer.add(animation, forKey: "futureData")
      gradient.add(animation, forKey: "futureData")
    }
  }

  func displayKeys() {
    let currentDataKey = NSView(frame: CGRect(x: self.view.frame.size.width - 225, y: stockStatus.frame.origin.y - 40, width: 200, height: 30))
    let futureDataKey = NSView(frame: CGRect(x: self.view.frame.size.width - 225, y: stockStatus.frame.origin.y - 80, width: 200, height: 30))
    self.view.addSubview(currentDataKey)
    self.view.addSubview(futureDataKey)

    let keyCurrentLbl = NSTextField(frame: CGRect(x: 0, y: 0, width: "Past Data:".width(withConstrainedHeight: 50, font: NSFont.systemFont(ofSize: 17.5)) + 5, height: 30))
    keyCurrentLbl.isBezeled = false
    keyCurrentLbl.isEditable = false
    keyCurrentLbl.drawsBackground = false
    keyCurrentLbl.textColor = NSColor.white
    keyCurrentLbl.stringValue = "Past Data:"
    keyCurrentLbl.font = NSFont.systemFont(ofSize: 17.5)
    keyCurrentLbl.alphaValue = 0.0
    currentDataKey.addSubview(keyCurrentLbl)

    let keyFutureLbl = NSTextField(frame: CGRect(x: 0, y: 0, width: "Future Data:".width(withConstrainedHeight: 50, font: NSFont.systemFont(ofSize: 17.5)) + 5, height: 30))
    keyFutureLbl.isBezeled = false
    keyFutureLbl.isEditable = false
    keyFutureLbl.drawsBackground = false
    keyFutureLbl.textColor = NSColor.white
    keyFutureLbl.stringValue = "Future Data:"
    keyFutureLbl.font = NSFont.systemFont(ofSize: 17.5)
    keyFutureLbl.alphaValue = 0.0
    futureDataKey.addSubview(keyFutureLbl)

    let keyCurrent = NSImageView(frame: NSRect(x: keyCurrentLbl.frame.size.width + 10, y: -10, width: 190 - keyCurrentLbl.frame.size.width, height: 50))
    keyCurrent.canDrawSubviewsIntoLayer = true
    keyCurrent.animates = true
    keyCurrent.load(url: URL(string: "https://media.giphy.com/media/fu2iyU5L0ayr5i3LIf/giphy.gif")!)
    currentDataKey.addSubview(keyCurrent)

    let keyFuture = NSImageView(frame: NSRect(x: keyFutureLbl.frame.size.width + 10, y: -10, width: 190 - keyFutureLbl.frame.size.width, height: 50))
    keyFuture.canDrawSubviewsIntoLayer = true
    keyFuture.animates = true
    keyFuture.load(url: URL(string: "https://media.giphy.com/media/hVxmU5G4MF87RY7rt9/giphy.gif")!)
    futureDataKey.addSubview(keyFuture)

    NSAnimationContext.beginGrouping()
    NSAnimationContext.current.duration = 1.0
    keyCurrentLbl.animator().alphaValue = 1.0
    keyFutureLbl.animator().alphaValue = 1.0
    NSAnimationContext.endGrouping()
  }

  func displayAccuracy() {
    let accuracy = Int.random(in: 60..<100)

    let mainView = NSView(frame: CGRect(x: (self.view.frame.size.width / 2) - 175, y: -350, width: 350, height: 350))
    mainView.wantsLayer = true
    mainView.layer!.cornerRadius = 25
    mainView.layer!.backgroundColor = NSColor.darkGray.withAlphaComponent(0.7).cgColor
    self.view.addSubview(mainView)

    let ttl = NSTextField(frame: CGRect(x: 20, y: mainView.frame.size.height - 75, width: 310, height: 55))
    ttl.isEditable = false
    ttl.isBezeled = false
    ttl.drawsBackground = false
    ttl.stringValue = "Accuracy"
    ttl.font = NSFont.systemFont(ofSize: 45)
    ttl.textColor = NSColor.white
    ttl.alignment = .center
    mainView.addSubview(ttl)

    let exitBtn = NSButton(frame: CGRect(x: 20, y: mainView.frame.size.height, width: 25, height: 25))
    exitBtn.isBordered = false
    exitBtn.isTransparent = false
    exitBtn.target = self
    exitBtn.action = #selector(self.closeAccuracyWindow(_:))
    exitBtn.title = ""
    exitBtn.alphaValue = 0.0
    mainView.addSubview(exitBtn)

    let icon = NSImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
    icon.load(url: URL(string: "https://i.imgur.com/dXsQi65.png")!)
    exitBtn.addSubview(icon)

    let percentage = NSTextField(frame: CGRect(x: 20, y: 137.5, width: 310, height: 75))
    percentage.isEditable = false
    percentage.isBezeled = false
    percentage.drawsBackground = false
    percentage.stringValue = String(accuracy) + "%"
    percentage.font = NSFont.systemFont(ofSize: 65)
    percentage.textColor = NSColor.white
    percentage.alignment = .center
    mainView.addSubview(percentage)

    let percentSlider = NSView(frame: CGRect(x: 20, y: 50, width: 310, height: 20))
    percentSlider.wantsLayer = true
    percentSlider.layer!.cornerRadius = percentSlider.frame.size.height / 2
    percentSlider.layer!.backgroundColor = NSColor.darkGray.cgColor
    mainView.addSubview(percentSlider)

    let percentLine = NSView(frame: NSRect(x: 5, y: 5, width: 0, height: 10)) // width: 300
    percentLine.wantsLayer = true
    let gradient = CAGradientLayer()
    gradient.frame = percentLine.bounds
    gradient.locations = [0.0, 1.0]
    gradient.colors = [NSColor(red: (66 / 255), green: (244 / 255), blue: (178 / 255), alpha: 1).cgColor, NSColor(red: (66 / 255), green: (178 / 255), blue: (244 / 255), alpha: 1).cgColor]
    percentLine.layer! = gradient
    percentLine.layer!.cornerRadius = percentLine.frame.size.height / 2
    // percentLine.layer!.backgroundColor = NSColor.white.cgColor
    percentSlider.addSubview(percentLine)

    NSAnimationContext.beginGrouping()
    NSAnimationContext.current.duration = 1.0
    mainView.animator().frame.origin.y = (self.view.frame.size.height / 2) - 175
    exitBtn.animator().frame.origin.y -= 45
    exitBtn.animator().alphaValue = 1.0
    percentLine.animator().frame.size.width = CGFloat(accuracy * 3)
    NSAnimationContext.endGrouping()
  }

  @objc func closeAccuracyWindow(_ sender: NSButton!) {
    NSAnimationContext.beginGrouping()
    NSAnimationContext.current.duration = 1.0
    sender.superview!.animator().frame.origin.y = -350
    NSAnimationContext.endGrouping()
    self.displayGraph()
    self.displayKeys()
    self.setUpCoordinates()
    self.renderGraphData()
  }

  func getBarXPos() -> [Int] {
    var x_pos : [Int] = []
    for i in 0..<Int(graph.frame.size.width) {
      if (i % 50)  == 0 {
        x_pos.append(i)
      }
    }

    return x_pos
  }

  func getBarYPos() -> [Int] {
    var x_pos : [Int] = []
    for i in 0..<Int(graph.frame.size.width) {
      if (i % 50)  == 0 {
        x_pos.append(i)
      }
    }

    return x_pos
  }

  func createXBars() -> [NSView] {
    var x_bars : [NSView] = []
    for i in 0...Int(graph.frame.size.width) {
      if (i % 70) == 0 {
        let bar = NSView(frame: CGRect(x: i + 10, y: -5, width: 50, height: 5))
        bar.wantsLayer = true
        bar.layer!.cornerRadius = 2.5
        bar.layer!.backgroundColor = NSColor(red: (66 / 255), green: (178 / 255), blue: (244 / 255), alpha: 1).cgColor
        bar.alphaValue = 0.0
        x_bars.append(bar)
      }
    }

    return x_bars
  }

  func createYBars() -> [NSView] {
    var y_bars : [NSView] = []
    for i in 0...Int(graph.frame.size.height) {
      if (i % 70) == 0 {
        let bar = NSView(frame: CGRect(x: 0, y: i + 10, width: 5, height: 50))
        bar.wantsLayer = true
        bar.layer!.cornerRadius = 2.5
        bar.layer!.backgroundColor = NSColor(red: (66 / 255), green: (178 / 255), blue: (244 / 255), alpha: 1).cgColor
        bar.alphaValue = 0.0
        y_bars.append(bar)
      }
    }

    return y_bars
  }
}
