import AppKit

class MainViewController : NSViewController, NSTextFieldDelegate {

  var gradientBackground : CAGradientLayer!

  var searchBtn : NSButton!
  var searchBG : NSView!

  let exitImage : URL = URL(string: "https://i.imgur.com/dXsQi65.png")!
  let searchImage : URL = URL(string: "https://i.imgur.com/LFsO6Dk.png")!

  var informationInfo : NSView!

  var featuredStocksView : NSView!
  let featuredStocksCells = [[Cell(frame: NSRect(x: 10, y: 005, width: 160, height: 100)), Cell(frame: NSRect(x: 180, y: 005, width: 160, height: 100))],
                             [Cell(frame: NSRect(x: 10, y: 115, width: 160, height: 100)), Cell(frame: NSRect(x: 180, y: 115, width: 160, height: 100))],
                             [Cell(frame: NSRect(x: 10, y: 225, width: 160, height: 100)), Cell(frame: NSRect(x: 180, y: 225, width: 160, height: 100))],
                             [Cell(frame: NSRect(x: 10, y: 335, width: 160, height: 100)), Cell(frame: NSRect(x: 180, y: 335, width: 160, height: 100))]]
  let stocks = ["AAPL", "FB", "GOOG", "MSFT", "GE", "TSLA", "INTC", "IBM"]
  let featuredStocksIcons : NSDictionary = ["AAPL": URL(string: "https://i.imgur.com/C14lCMv.png")!,
                                            "FB":   URL(string: "https://i.imgur.com/MbP2fVS.png")!,
                                            "GE":   URL(string: "https://i.imgur.com/49Ai7Y2.png")!,
                                            "GOOG": URL(string: "https://i.imgur.com/IHfPVj3.png")!,
                                            "IBM":  URL(string: "https://i.imgur.com/9qrrjDF.png")!,
                                            "INTC": URL(string: "https://i.imgur.com/SVi06zK.png")!,
                                            "MSFT": URL(string: "https://i.imgur.com/U0IwmpN.png")!,
                                            "TSLA": URL(string: "https://i.imgur.com/LdyUucD.png")!]

  var featuredTickerView : NSView!
  let indices = ["^DJI", "^GSPC", "^IXIC", "^RUT", "CL=F", "GC=F", "SI=F", "EURUSD=X", "^TNX", "^VIX"]
  let featuredTickerCells = [[Cell(frame: NSRect(x: 10, y: 005, width: 160, height: 100)), Cell(frame: NSRect(x: 180, y: 005, width: 160, height: 100))],
                             [Cell(frame: NSRect(x: 10, y: 115, width: 160, height: 100)), Cell(frame: NSRect(x: 180, y: 115, width: 160, height: 100))],
                             [Cell(frame: NSRect(x: 10, y: 225, width: 160, height: 100)), Cell(frame: NSRect(x: 180, y: 225, width: 160, height: 100))],
                             [Cell(frame: NSRect(x: 10, y: 335, width: 160, height: 100)), Cell(frame: NSRect(x: 180, y: 335, width: 160, height: 100))]]

  override func loadView() {
    self.view = NSView(frame: CGRect(x: 0, y: 0, width: 1000, height: 650))
    self.view.wantsLayer = true
    let colorTop = NSColor(red: 87 / 255, green: 202 / 255, blue: 133 / 255, alpha: 1).cgColor
    let colorBottom = NSColor(red: 24 / 255, green: 78 / 255, blue: 104 / 255, alpha: 1).cgColor
    gradientBackground  = CAGradientLayer()
    gradientBackground.colors = [colorTop, colorBottom]
    self.view.layer! = gradientBackground
    self.view.layer!.cornerRadius = 35
    self.view.layer!.maskedCorners = [.layerMaxXMaxYCorner]

    self.view.autoresizesSubviews = true
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do view setup here.

    self.displaySearchBtn()
    self.displayFeaturedSection()
    self.constructInformationView()
  }

  func displaySearchBtn() {
    searchBtn = NSButton(frame: NSRect(x: self.view.bounds.size.width - 60, y: self.view.bounds.size.height - 80, width: 45, height: 45))
    searchBtn.isBordered = false
    searchBtn.isTransparent = false
    searchBtn.action = #selector(self.displaySearchView)
    searchBtn.title = ""
    searchBtn.alphaValue = 0
    searchBtn.wantsLayer = true
    searchBtn.layer!.cornerRadius = 15
    searchBtn.layer!.masksToBounds = true
    searchBtn.autoresizingMask = [.maxXMargin, .maxYMargin]
    searchBtn.layer!.backgroundColor = NSColor.black.withAlphaComponent(0.35).cgColor
    searchBtn.addSubview(NSImageView(frame: NSRect(x: 10, y: 10, width: 25, height: 25)))
    (searchBtn.subviews[0] as? NSImageView)!.load(url: searchImage)
    self.view.addSubview(searchBtn)

    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      NSAnimationContext.beginGrouping()
      NSAnimationContext.current.duration = 1.0
      self.searchBtn.animator().alphaValue = 1.0
      self.searchBtn.animator().frame.origin.y = self.self.view.bounds.size.height - 60
      NSAnimationContext.endGrouping()
    }
  }

  @objc func displaySearchView() {
    searchBG = NSView(frame: self.view.bounds)
    searchBG.wantsLayer = true
    searchBG.layer!.cornerRadius = 35
    searchBG.layer!.maskedCorners = [.layerMaxXMaxYCorner]
    searchBG.layer!.backgroundColor = NSColor.black.withAlphaComponent(0.85).cgColor
    searchBG.frame.origin.y = searchBG.frame.size.height
    self.view.addSubview(searchBG)
    NSAnimationContext.beginGrouping()
    NSAnimationContext.current.duration = 0.5
    searchBG.animator().frame.origin.y = 0
    NSAnimationContext.endGrouping()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      let searchIcon = NSImageView(frame: CGRect(x: 150, y: self.self.view.bounds.size.height / 2, width: 75, height: 75))
      searchIcon.load(url: self.searchImage)
      searchIcon.alphaValue = 0.0
      self.searchBG.addSubview(searchIcon)
      let searchUnderline = NSView(frame: CGRect(x: 470, y: searchIcon.frame.origin.y + 150, width: 0, height: 5))
      searchUnderline.wantsLayer = true
      searchUnderline.layer!.backgroundColor = NSColor.white.cgColor
      self.searchBG.addSubview(searchUnderline)
      let searchField = NSTextField(frame: CGRect(x: 240, y: searchUnderline.frame.origin.y, width: self.self.view.bounds.size.width - 360, height: 75))
      searchField.textColor = NSColor.white
      searchField.delegate = self
      searchField.drawsBackground = false
      searchField.isBezeled = false
      searchField.focusRingType = .none
      searchField.font = NSFont.systemFont(ofSize: 75)
      searchField.becomeFirstResponder()
      self.searchBG.addSubview(searchField)
      let exitBtn = NSButton(frame: CGRect(x: self.self.view.bounds.size.width - 60, y: self.self.view.bounds.size.height - 35, width: 35, height: 35))
      exitBtn.isBordered = false
      exitBtn.isTransparent = false
      exitBtn.action = #selector(self.hideSearchView)
      exitBtn.title = ""
      exitBtn.alphaValue = 0
      exitBtn.addSubview(NSImageView(frame: NSRect(x: 0, y: 0, width: 35, height: 35)))
      (exitBtn.subviews[0] as? NSImageView)!.load(url: self.exitImage)
      self.searchBG.addSubview(exitBtn)
      NSAnimationContext.beginGrouping()
      NSAnimationContext.current.duration = 1.0
      searchIcon.animator().alphaValue = 1.0
      searchIcon.animator().frame.origin.y += 150
      searchUnderline.animator().frame.origin.x = 240
      searchUnderline.animator().frame.size.width = self.view.bounds.size.width - 480
      exitBtn.animator().alphaValue = 1.0
      exitBtn.animator().frame.origin.y -= 40
      NSAnimationContext.endGrouping()

      // Initial scrollview
      let autocompleteView = NSScrollView(frame: CGRect(x: 470, y: (self.view.frame.size.height / 2) + 150, width: self.view.bounds.size.width - 480, height: 100))
      autocompleteView.translatesAutoresizingMaskIntoConstraints = false
      autocompleteView.borderType = .noBorder
      autocompleteView.backgroundColor = NSColor.gray
      autocompleteView.hasVerticalScroller = true
      self.searchBG.addSubview(autocompleteView)

      // Initial clip view
      let clipView = NSClipView()
      clipView.translatesAutoresizingMaskIntoConstraints = false
      autocompleteView.contentView = clipView
      autocompleteView.addConstraint(NSLayoutConstraint(item: clipView, attribute: .left, relatedBy: .equal, toItem: autocompleteView, attribute: .left, multiplier: 1.0, constant: 0))
      autocompleteView.addConstraint(NSLayoutConstraint(item: clipView, attribute: .top, relatedBy: .equal, toItem: autocompleteView, attribute: .top, multiplier: 1.0, constant: 0))
      autocompleteView.addConstraint(NSLayoutConstraint(item: clipView, attribute: .right, relatedBy: .equal, toItem: autocompleteView, attribute: .right, multiplier: 1.0, constant: 0))
      autocompleteView.addConstraint(NSLayoutConstraint(item: clipView, attribute: .bottom, relatedBy: .equal, toItem: autocompleteView, attribute: .bottom, multiplier: 1.0, constant: 0))

      // Initial document view
      let documentView = NSView()
      documentView.translatesAutoresizingMaskIntoConstraints = false
      autocompleteView.documentView = documentView
      clipView.addConstraint(NSLayoutConstraint(item: clipView, attribute: .left, relatedBy: .equal, toItem: documentView, attribute: .left, multiplier: 1.0, constant: 0))
      clipView.addConstraint(NSLayoutConstraint(item: clipView, attribute: .top, relatedBy: .equal, toItem: documentView, attribute: .top, multiplier: 1.0, constant: 0))
      clipView.addConstraint(NSLayoutConstraint(item: clipView, attribute: .right, relatedBy: .equal, toItem: documentView, attribute: .right, multiplier: 1.0, constant: 0))
    }
  }

  @objc func hideSearchView() {
    NSAnimationContext.beginGrouping()
    NSAnimationContext.current.duration = 1.0
    searchBG.animator().frame.origin.y = self.view.frame.size.height
    searchBG.subviews[0].animator().frame.origin.y -= 150
    searchBG.subviews[0].animator().alphaValue = 1.0
    searchBG.subviews[1].animator().frame.origin.x = 470
    searchBG.subviews[1].animator().frame.size.width = 0
    searchBG.subviews[3].animator().alphaValue = 0.0
    searchBG.subviews[3].animator().frame.origin.y += 50
    NSAnimationContext.endGrouping()
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { self.searchBG.removeFromSuperview() }
  }

  func controlTextDidChange(_ obj: Notification) {
    let autocomplete = (obj.object as! NSTextField).stringValue
    let task = Process()
    task.launchPath = "/usr/bin/python"
    task.arguments = ["../../Data/AutoComplete/autocomplete_ticker_name.py", autocomplete]
    task.launch()
    task.waitUntilExit()

    let data = readJSONFromFile(fileName: "../../Data/AutoComplete/autocomplete")
    let startingPoint = (self.view.frame.size.height / 2) - 150
    for i in 0..<(data as! NSArray).count {
      let contentView = NSView(frame: CGRect(x: 470, y: startingPoint + CGFloat(50 * (i + 1)), width: searchBG.subviews[1].frame.size.width, height: 50))
      searchBG.addSubview(contentView)
    }
  }

  func readJSONFromFile(fileName: String) -> Any? {
    var json: Any?
    if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
      do {
        let fileUrl = URL(fileURLWithPath: path)
        // Getting data from JSON file using the file's local path
        let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
        json = try? JSONSerialization.jsonObject(with: data)
      } catch {
        // Handle error here
      }
    }
    return json
  }

  func constructInformationView() {
    informationInfo = NSView(frame: CGRect(x: 0, y: -75, width: self.view.frame.size.width, height: 75))
    informationInfo.wantsLayer = true
    informationInfo.layer!.cornerRadius = 25
    informationInfo.layer!.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    informationInfo.layer!.backgroundColor = NSColor.black.withAlphaComponent(0.65).cgColor
    self.view.addSubview(informationInfo)

    informationInfo.addSubview(NSImageView(frame: CGRect(x: 15, y: 15, width: 100, height: 50)))

    let symbolTitle = NSTextField(frame: CGRect(x: 110, y: 15, width: 150, height: 50))
    symbolTitle.drawsBackground = false
    symbolTitle.isBezeled = false
    symbolTitle.textColor = NSColor.white
    symbolTitle.font = NSFont.labelFont(ofSize: 45)
    symbolTitle.isEditable = false
    informationInfo.addSubview(symbolTitle)

    let region = NSTextField(frame: CGRect(x: 245, y: 37.5, width: 200, height: 25))
    region.drawsBackground = false
    region.isBezeled = false
    region.textColor = NSColor.lightGray
    region.font = NSFont.labelFont(ofSize: 25)
    region.isEditable = false
    informationInfo.addSubview(region)

    let fullName = NSTextField(frame: CGRect(x: 245, y: 37.5 - 25, width: 800, height: 30))
    fullName.drawsBackground = false
    fullName.isBezeled = false
    fullName.textColor = NSColor.lightGray
    fullName.font = NSFont.labelFont(ofSize: 25)
    fullName.isEditable = false
    informationInfo.addSubview(fullName)

    let currentPrice = NSTextField(frame: CGRect(x: informationInfo.frame.size.width - 125, y: 37.5, width: 125, height: 30))
    currentPrice.drawsBackground = false
    currentPrice.isBezeled = false
    currentPrice.textColor = NSColor.lightGray
    currentPrice.font = NSFont.labelFont(ofSize: 30)
    currentPrice.isEditable = false
    informationInfo.addSubview(currentPrice)

    let priceChange = NSTextField(frame: CGRect(x: informationInfo.frame.size.width - 135, y: 7.5, width: 62.5, height: 30))
    priceChange.drawsBackground = false
    priceChange.isBezeled = false
    priceChange.font = NSFont.labelFont(ofSize: 20)
    priceChange.isEditable = false
    informationInfo.addSubview(priceChange)

    let percentPriceChange = NSTextField(frame: CGRect(x: informationInfo.frame.size.width - 80, y: 7.5, width: 80, height: 30))
    percentPriceChange.drawsBackground = false
    percentPriceChange.isBezeled = false
    percentPriceChange.font = NSFont.labelFont(ofSize: 20)
    percentPriceChange.isEditable = false
    informationInfo.addSubview(percentPriceChange)

    let typeOfSecurity = NSTextField(frame: CGRect(x: currentPrice.frame.origin.x - 175, y: 0, width: 175, height: 75))
    typeOfSecurity.drawsBackground = false
    typeOfSecurity.isBezeled = false
    typeOfSecurity.font = NSFont.labelFont(ofSize: 45)
    typeOfSecurity.isEditable = false
    informationInfo.addSubview(typeOfSecurity)
  }

  func displayFeaturedSection() {
    featuredStocksView = NSView(frame: CGRect(x: 100, y: 75, width: 350, height: 500))
    let featuredStocksTTL = NSTextField(frame: CGRect(x: 0, y: 475, width: 350, height: 45))
    featuredStocksTTL.isEditable = false
    featuredStocksTTL.drawsBackground = false
    featuredStocksTTL.isBezeled = false
    featuredStocksTTL.focusRingType = .none
    featuredStocksTTL.font = NSFont.systemFont(ofSize: 35)
    featuredStocksTTL.textColor = NSColor.white
    featuredStocksTTL.stringValue = "Featured Stocks"
    featuredStocksTTL.alignment = .center
    featuredStocksTTL.alphaValue = 0.0
    featuredStocksView.addSubview(featuredStocksTTL)
    self.view.addSubview(featuredStocksView)

    featuredTickerView = NSView(frame: CGRect(x: 550, y: 75, width: 350, height: 500))
    let featuredTickerTTL = NSTextField(frame: CGRect(x: 0, y: 475, width: 350, height: 45))
    featuredTickerTTL.isEditable = false
    featuredTickerTTL.drawsBackground = false
    featuredTickerTTL.isBezeled = false
    featuredTickerTTL.focusRingType = .none
    featuredTickerTTL.font = NSFont.systemFont(ofSize: 35)
    featuredTickerTTL.textColor = NSColor.white
    featuredTickerTTL.stringValue = "Featured Tickers"
    featuredTickerTTL.alignment = .center
    featuredTickerTTL.alphaValue = 0.0
    featuredTickerView.addSubview(featuredTickerTTL)
    self.view.addSubview(featuredTickerView)

    featuredStocksView.addTrackingArea(NSTrackingArea.init(rect: featuredStocksView.bounds, options: [NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.activeAlways], owner: self, userInfo: nil))
    featuredTickerView.addTrackingArea(NSTrackingArea.init(rect: featuredTickerView.bounds, options: [NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.activeAlways], owner: self, userInfo: nil))

    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      NSAnimationContext.beginGrouping()
      NSAnimationContext.current.duration = 1.0
      featuredStocksTTL.animator().alphaValue = 1.0
      featuredStocksTTL.animator().frame.origin.y -= 25
      featuredTickerTTL.animator().alphaValue = 1.0
      featuredTickerTTL.animator().frame.origin.y -= 25
      NSAnimationContext.endGrouping()
    }

    displayFeaturedStocksCells()
    displayFeaturedTickerCells()
  }

  func displayFeaturedStocksCells() {
    var counter = 0
    for sub_cells in featuredStocksCells {
      for cell in sub_cells {
        cell.attribute = stocks[counter]
        cell.action = #selector(self.calculateStock(_:))
        cell.isBordered = false
        cell.isTransparent = false
        cell.title = ""
        cell.alphaValue = 0.0
        cell.wantsLayer = true
        cell.layer!.backgroundColor = NSColor.lightGray.cgColor
        cell.layer!.cornerRadius = 15
        cell.layer!.masksToBounds = true
        self.featuredStocksView.addSubview(cell)

        let iconView = NSImageView(frame: CGRect(x: (cell.frame.size.width / 2) - 25, y: 25, width: 50, height: 50))
        iconView.load(url: featuredStocksIcons[stocks[counter]] as! URL)
        cell.addSubview(iconView)

        counter += 1
        cell.addTrackingArea(NSTrackingArea.init(rect: cell.bounds, options: [NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.activeAlways], owner: self, userInfo: nil))

        let originY = cell.frame.origin.y
        cell.frame.origin.y = 005

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          NSAnimationContext.beginGrouping()
          NSAnimationContext.current.duration = 1.0
          cell.animator().alphaValue = 1.0
          cell.animator().frame.origin.y = originY
          NSAnimationContext.endGrouping()
        }
      }
    }
  }

  func displayFeaturedTickerCells() {
    var counter = 0
    for sub_cells in featuredTickerCells {
      for cell in sub_cells {
        cell.attribute = tickers[counter]
        cell.action = #selector(self.calculateStock(_:))
        cell.isBordered = false
        cell.isTransparent = false
        cell.title = ""
        cell.alphaValue = 0.0
        cell.wantsLayer = true
        cell.layer!.backgroundColor = NSColor.lightGray.cgColor
        cell.layer!.cornerRadius = 15
        cell.layer!.masksToBounds = true
        self.featuredTickerView.addSubview(cell)

        let iconView = NSTextField(frame: CGRect(x: 16, y: 25, width: 128, height: 100))
        iconView.stringValue = tickers[counter]
        iconView.textColor = NSColor.white
        iconView.font = NSFont.systemFont(ofSize: 30)
        iconView.alignment = .center
        iconView.isBezeled = false
        iconView.drawsBackground = false
        iconView.isEditable = false
        cell.addSubview(iconView)

        counter += 1
        cell.addTrackingArea(NSTrackingArea.init(rect: cell.bounds, options: [NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.activeAlways], owner: self, userInfo: nil))

        let originY = cell.frame.origin.y
        cell.frame.origin.y = 005

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          NSAnimationContext.beginGrouping()
          NSAnimationContext.current.duration = 1.0
          cell.animator().alphaValue = 1.0
          cell.animator().frame.origin.y = originY
          NSAnimationContext.endGrouping()
        }
      }
    }
  }

  @objc func calculateStock(_ sender: Cell!) {
    // Calculate the stock data thing
  }

  func displayInformation(with event: NSEvent) {
    let data = readJSONFromFile(fileName: "../../Data/FeaturedStocks/featuredstocks")
    for cells in featuredStocksCells {
      for cell in cells {
        if cell.frame.contains(event.locationInWindow) {
          (informationInfo.subviews[0] as? NSImageView)!.image = (cell.subviews[0] as? NSImageView)!.image
          for i in 0..<(data as? NSArray)!.count {
            let symbol = (((data as? NSArray)![i] as? NSDictionary)!["symbol"] as? String)!
            let regionInfo = (((data as? NSArray)![i] as? NSDictionary)!["region"] as? String)! + ":" + (((data as? NSArray)![i] as? NSDictionary)!["fullExchangeName"] as? String)!
            let fullName = (((data as? NSArray)![i] as? NSDictionary)!["longName"] as? String)!
            let currentPrice = (((data as? NSArray)![i] as? NSDictionary)!["ask"] as? CGFloat)!
            let priceChange = (((data as? NSArray)![i] as? NSDictionary)!["regularMarketChange"] as? CGFloat)!
            let percentPriceChange = (((data as? NSArray)![i] as? NSDictionary)!["regularMarketChangePercent"] as? CGFloat)!
            let quoteType = (((data as? NSArray)![i] as? NSDictionary)!["quoteType"] as? String)!
            if symbol == cell.attribute {
              (informationInfo.subviews[2] as? NSTextField)!.frame.origin.x = 120 + symbol.width(withConstrainedHeight: 50, font: NSFont.systemFont(ofSize: 45))
              (informationInfo.subviews[3] as? NSTextField)!.frame.origin.x = 120 + symbol.width(withConstrainedHeight: 50, font: NSFont.systemFont(ofSize: 45))

              if priceChange > 0 {
                (informationInfo.subviews[5] as? NSTextField)!.stringValue = "+"
                (informationInfo.subviews[5] as? NSTextField)!.textColor = NSColor(red: (66 / 255), green: (244 / 255), blue: (66 / 255), alpha: 1)
              }
              (informationInfo.subviews[5] as? NSTextField)!.stringValue += "\(priceChange)"

              if percentPriceChange > 0 {
                (informationInfo.subviews[6] as? NSTextField)!.stringValue = "+"
                (informationInfo.subviews[6] as? NSTextField)!.textColor = NSColor(red: (66 / 255), green: (244 / 255), blue: (66 / 255), alpha: 1)
              }

              (informationInfo.subviews[1] as? NSTextField)!.stringValue = symbol
              (informationInfo.subviews[2] as? NSTextField)!.stringValue = regionInfo
              (informationInfo.subviews[3] as? NSTextField)!.stringValue = fullName

              (informationInfo.subviews[4] as? NSTextField)!.stringValue = String(format: "$%.2f", currentPrice)
              (informationInfo.subviews[5] as? NSTextField)!.stringValue = String(format: "$%.2f", priceChange)
              (informationInfo.subviews[6] as? NSTextField)!.stringValue += String(format: "%.2f%%", percentPriceChange)

              (informationInfo.subviews[7] as? NSTextField)!.stringValue = quoteType

              break
            }
          }
        }
      }
    }
  }

  override func mouseEntered(with event: NSEvent) {
    displayInformation(with: event)
    if featuredStocksView.frame.contains(event.locationInWindow) {
      animateBackground(topColor: NSColor(red: (227 / 255), green: (122 / 255), blue: (92 / 255), alpha: 1),
      bottomColor: NSColor(red: (190 / 255), green: (132 / 255), blue: (152 / 255), alpha: 1),
    fillMode: .forwards)
    informationInfo.frame.size.width = self.view.frame.size.width
    NSAnimationContext.beginGrouping()
    NSAnimationContext.current.duration = 1.0
    informationInfo.animator().frame.origin.y = 0
    NSAnimationContext.endGrouping()
  } else if featuredTickerView.frame.contains(event.locationInWindow) {
    animateBackground(topColor: NSColor(red: (76 / 255), green: (116 / 255), blue: (128 / 255), alpha: 1),
    bottomColor: NSColor(red: (54 / 255), green: (59 / 255), blue: (79 / 255), alpha: 1),
  fillMode: .forwards)
}
}

override func mouseExited(with event: NSEvent) {
  animateBackground(topColor: NSColor(red: 87 / 255, green: 202 / 255, blue: 133 / 255, alpha: 1),
  bottomColor: NSColor(red: 24 / 255, green: 78 / 255, blue: 104 / 255, alpha: 1),
fillMode: .forwards)
NSAnimationContext.beginGrouping()
NSAnimationContext.current.duration = 1.0
informationInfo.animator().frame.origin.y = -75
NSAnimationContext.endGrouping()
}

func animateBackground(topColor: NSColor, bottomColor: NSColor, fillMode: CAMediaTimingFillMode) {
  let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
  gradientChangeAnimation.duration = 1.0
  gradientChangeAnimation.fromValue = gradientBackground.colors
  gradientChangeAnimation.toValue = [topColor.cgColor, bottomColor.cgColor]
  gradientChangeAnimation.fillMode = fillMode
  gradientChangeAnimation.isRemovedOnCompletion = false
  gradientChangeAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
  gradientBackground.add(gradientChangeAnimation, forKey: "colorChange")
}
}


public class Cell: NSButton {

  var attribute : String!

  public override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)
  }
}

extension String {
  func width(withConstrainedHeight height: CGFloat, font: NSFont) -> CGFloat {
    let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
    let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

    return ceil(boundingBox.width)
  }
}

extension NSImageView {
  func load(url: URL) {
    DispatchQueue.global().async { [weak self] in
      if let data = try? Data(contentsOf: url) {
        if let image = NSImage(data: data) {
          DispatchQueue.main.async {
            self?.image = image
          }
        }
      }
    }
  }
}
