import AppKit

class MainViewController : NSViewController, NSWindowDelegate, NSTextFieldDelegate {

  var gradientBackground : CAGradientLayer!

  var searchBtn : NSButton!
  var searchBG : NSView!
  var inSearchView : Bool = false

  let exitImage : URL = URL(string: "https://i.imgur.com/dXsQi65.png")!
  let searchImage : URL = URL(string: "https://i.imgur.com/LFsO6Dk.png")!

  let autocompleteView = NSScrollView()
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
  let featuredTickerCells = [[Cell(frame: NSRect(x: 10, y: 005, width: 160, height: 100)), Cell(frame: NSRect(x: 180, y: 005, width: 160, height: 100))],
                             [Cell(frame: NSRect(x: 10, y: 115, width: 160, height: 100)), Cell(frame: NSRect(x: 180, y: 115, width: 160, height: 100))],
                             [Cell(frame: NSRect(x: 10, y: 225, width: 160, height: 100)), Cell(frame: NSRect(x: 180, y: 225, width: 160, height: 100))],
                             [Cell(frame: NSRect(x: 10, y: 335, width: 160, height: 100)), Cell(frame: NSRect(x: 180, y: 335, width: 160, height: 100))]]
  let indices = ["^DJI", "^GSPC", "^IXIC", "^RUT", "CL=F", "GC=F", "SI=F", "EURUSD=X", "^TNX", "^VIX"]
  let featuredIndexIcons : NSDictionary = ["^DJI":     URL(string: "https://i.imgur.com/azjHHiP.png")!,
                                           "^GSPC":    URL(string: "https://i.imgur.com/NocRaIQ.png")!,
                                           "^IXIC":    URL(string: "https://i.imgur.com/8HnIqFG.png")!,
                                           "^RUT":     URL(string: "https://i.imgur.com/38dM7jh.png")!,
                                           "CL=F":     URL(string: "https://i.imgur.com/jP2z8lL.png")!,
                                           "GC=F":     URL(string: "https://i.imgur.com/BQrTiya.png")!,
                                           "SI=F":     URL(string: "https://i.imgur.com/qi1uybo.png")!,
                                           "EURUSD=X": URL(string: "https://i.imgur.com/VXEV3XS.png")!,
                                           "^TNX":     URL(string: "https://i.imgur.com/4SeigXn.png")!,
                                           "^VIX":     URL(string: "https://i.imgur.com/g8c6BGB.png")!]

  override func loadView() {
    self.view = NSView(frame: CGRect(x: 0, y: 0, width: 1000, height: 650))
    self.view.wantsLayer = true
    let colorTop = NSColor(red: 80 / 255, green: 98 / 255, blue: 93 / 255, alpha: 1).cgColor
    let colorBottom = NSColor(red: 38 / 255, green: 43 / 255, blue: 60 / 255, alpha: 1).cgColor
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

    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      self.animateBackground(topColor: NSColor(red: (54 / 255), green: (57 / 255), blue: (77 / 255), alpha: 1),
                             bottomColor: NSColor(red: (77 / 255), green: (126 / 255), blue: (129 / 255), alpha: 1),
                             fillMode: .forwards)
    }
  }

  override func viewDidAppear() {
    self.view.window!.delegate = self
  }

  func windowWillResize(notification: NSNotification) {
    print("CALLED")
    self.searchBtn.frame.origin = NSPoint(x: self.view.bounds.size.width - 60, y: self.view.bounds.size.height - 80)
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
    if !inSearchView {
      inSearchView = true
      searchBG = NSView(frame: self.view.bounds)
      searchBG.wantsLayer = true
      searchBG.layer!.cornerRadius = 35
      searchBG.layer!.maskedCorners = [.layerMaxXMaxYCorner]
      searchBG.layer!.backgroundColor = NSColor.black.withAlphaComponent(0.85).cgColor
      searchBG.alphaValue = 0.0
      self.view.addSubview(searchBG)
      let searchIcon = NSImageView(frame: CGRect(x: 150, y: self.view.bounds.size.height / 2, width: 75, height: 75))
      searchIcon.load(url: self.searchImage)
      searchIcon.alphaValue = 0.0
      self.searchBG.addSubview(searchIcon)
      let searchUnderline = NSView(frame: CGRect(x: 470, y: searchIcon.frame.origin.y + 150, width: 0, height: 5))
      searchUnderline.wantsLayer = true
      searchUnderline.layer!.backgroundColor = NSColor.white.cgColor
      self.searchBG.addSubview(searchUnderline)
      let searchField = NSTextField(frame: CGRect(x: 240, y: searchUnderline.frame.origin.y + 5, width: self.view.bounds.size.width - 360, height: 75))
      searchField.textColor = NSColor.white
      searchField.delegate = self
      searchField.drawsBackground = false
      searchField.isBezeled = false
      searchField.focusRingType = .none
      searchField.font = NSFont.systemFont(ofSize: 75)
      searchField.becomeFirstResponder()
      self.searchBG.addSubview(searchField)
      let exitBtn = NSButton(frame: CGRect(x: self.self.view.bounds.size.width - 60, y: self.view.bounds.size.height - 35, width: 35, height: 35))
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
      searchBG.animator().alphaValue = 1.0
      searchIcon.animator().alphaValue = 1.0
      searchIcon.animator().frame.origin.y += 150
      searchUnderline.animator().frame.origin.x = 240
      searchUnderline.animator().frame.size.width = self.view.bounds.size.width - 480
      exitBtn.animator().alphaValue = 1.0
      exitBtn.animator().frame.origin.y -= 40
      NSAnimationContext.endGrouping()

      // Initial scrollview
      self.autocompleteView.frame = CGRect(x: 150, y: 20, width: self.view.bounds.size.width - 300, height: self.view.frame.size.height - (self.view.frame.size.height - searchUnderline.frame.origin.y) - 50)
      self.autocompleteView.translatesAutoresizingMaskIntoConstraints = false
      self.autocompleteView.borderType = .noBorder
      self.autocompleteView.hasVerticalScroller = true
      self.autocompleteView.drawsBackground = false
      self.searchBG.addSubview(self.autocompleteView)

      // Initial clip view
      let documentView = NSClipView()
      documentView.translatesAutoresizingMaskIntoConstraints = false
      documentView.drawsBackground = false
      self.autocompleteView.contentView = documentView

      // Initial document view
      self.autocompleteView.documentView = NSView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width - 300, height: self.view.frame.size.height - (self.view.frame.size.height - searchUnderline.frame.origin.y) - 50))
    }
  }

  @objc func hideSearchView() {
    inSearchView = false
    NSAnimationContext.beginGrouping()
    NSAnimationContext.current.duration = 1.0
    searchBG.subviews[0].animator().frame.origin.y -= 150
    searchBG.subviews[0].animator().alphaValue = 1.0
    searchBG.subviews[1].animator().frame.origin.x = 470
    searchBG.subviews[1].animator().frame.size.width = 0
    searchBG.subviews[3].animator().alphaValue = 0.0
    searchBG.subviews[3].animator().frame.origin.y += 50
    searchBG.animator().alphaValue = 0.0
    NSAnimationContext.endGrouping()
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { self.searchBG.removeFromSuperview() }
  }

  func controlTextDidEndEditing(_ obj: Notification) {
    (searchBG.subviews.last! as? NSScrollView)!.documentView!.subviews.forEach {
      NSAnimationContext.beginGrouping()
      NSAnimationContext.current.duration = 1.0
      $0.animator().alphaValue = 0.0
      $0.animator().frame.origin.y += 25
      NSAnimationContext.endGrouping()
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      (self.searchBG.subviews.last! as? NSScrollView)!.documentView!.subviews.forEach { $0.removeFromSuperview() }
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
      let loadingIndicator = NSProgressIndicator(frame: CGRect(x: (self.searchBG.subviews.last!.frame.size.width / 2) - 15, y: 50, width: 30, height: 30))
      loadingIndicator.style = .spinning
      loadingIndicator.controlSize = .regular
      loadingIndicator.isBezeled = false
      loadingIndicator.sizeToFit()
      loadingIndicator.isDisplayedWhenStopped = false
      loadingIndicator.alphaValue = 0.0
      self.searchBG.subviews.last!.addSubview(loadingIndicator)
      loadingIndicator.startAnimation(self)
      NSAnimationContext.beginGrouping()
      NSAnimationContext.current.duration = 1.0
      loadingIndicator.animator().alphaValue = 1.0
      NSAnimationContext.endGrouping()

      let autoCompleteTask = Process()
      autoCompleteTask.executableURL = URL(fileURLWithPath: "/usr/bin/python")
      autoCompleteTask.arguments = ["../../Data/AutoComplete/autocomplete_ticker_name.py", (self.searchBG.subviews[2] as? NSTextField)!.stringValue]
      do {
        try autoCompleteTask.launch()
        autoCompleteTask.waitUntilExit()

        loadingIndicator.stopAnimation(self)

        let autoCompleteData = JSON.readJSONFromFile(fileName: "../../Data/AutoComplete/autocomplete") as? NSArray
        var y_pos : CGFloat = 20
        for i in 0..<autoCompleteData!.count {
          let card = Cell(frame: CGRect(x: 20, y: 20, width: Int(self.view.frame.size.width) - 340, height: 75))
          y_pos += 95
          card.attribute = ((autoCompleteData![autoCompleteData!.count - 1 - i] as? NSDictionary)!["symbol"] as? String)!
          card.action = #selector(self.calculateStock(_:))
          card.isBordered = false
          card.isTransparent = false
          card.title = ""
          card.wantsLayer = true
          card.layer!.cornerRadius = 5
          card.layer!.backgroundColor = NSColor.black.withAlphaComponent(0.8).cgColor
          card.alphaValue = 0.0
          (self.searchBG.subviews.last! as? NSScrollView)!.documentView!.addSubview(card)

          let stock = NSTextField(frame: CGRect(x: 20, y: 5, width: 200, height: 30))
          stock.isBezeled = false
          stock.isEditable = false
          stock.drawsBackground = false
          stock.textColor = NSColor.white
          stock.font = NSFont.boldSystemFont(ofSize: 25)
          stock.stringValue = ((autoCompleteData![autoCompleteData!.count - 1 - i] as? NSDictionary)!["symbol"] as? String)!
          card.addSubview(stock)

          let fullName = NSTextField(frame: CGRect(x: 20, y: 35, width: 200, height: 30))
          fullName.isBezeled = false
          fullName.isEditable = false
          fullName.drawsBackground = false
          fullName.textColor = NSColor.lightGray
          fullName.font = NSFont.systemFont(ofSize: 25)
          fullName.stringValue = ((autoCompleteData![autoCompleteData!.count - 1 - i] as? NSDictionary)!["longName"] as? String)!
          card.addSubview(fullName)

          let exchange = NSTextField(frame: CGRect(x: 25 + ((autoCompleteData![autoCompleteData!.count - 1 - i] as? NSDictionary)!["symbol"] as? String)!.width(withConstrainedHeight: 75, font: NSFont.boldSystemFont(ofSize: 25)), y: 15, width: 200, height: 20))
          exchange.isBezeled = false
          exchange.isEditable = false
          exchange.drawsBackground = false
          exchange.textColor = NSColor.lightGray
          exchange.font = NSFont.systemFont(ofSize: 15)
          exchange.stringValue = ((autoCompleteData![autoCompleteData!.count - 1 - i] as? NSDictionary)!["region"] as? String)! + ":" + ((autoCompleteData![autoCompleteData!.count - 1 - i] as? NSDictionary)!["fullExchangeName"] as? String)!
          card.addSubview(exchange)

          let price = ((autoCompleteData?[autoCompleteData!.count - 1 - i] as? NSDictionary)?["ask"] as? CGFloat) ?? 0.0

          let currentPrice = NSTextField(frame: CGRect(x: card.frame.size.width - 20 - String(format: "%.2f", price).width(withConstrainedHeight: 30, font: NSFont.systemFont(ofSize: 25)), y: 5, width: 200, height: 30))
          currentPrice.isBezeled = false
          currentPrice.isEditable = false
          currentPrice.drawsBackground = false
          currentPrice.textColor = NSColor.darkGray
          currentPrice.font = NSFont.systemFont(ofSize: 25)
          currentPrice.stringValue = String(format: "%.2f", price)
          card.addSubview(currentPrice)

          let percent = ((autoCompleteData![autoCompleteData!.count - 1 - i] as? NSDictionary)!["regularMarketChangePercent"] as? CGFloat)!

          let percentChange = NSTextField(frame: CGRect(x: 0, y: 35, width: 200, height: 20))
          percentChange.isBezeled = false
          percentChange.isEditable = false
          percentChange.drawsBackground = false
          percentChange.font = NSFont.systemFont(ofSize: 20)
          if percent > 0 {
            percentChange.stringValue = "+"
            percentChange.textColor = NSColor(red: (66 / 255), green: (244 / 255), blue: (66 / 255), alpha: 1)
          } else {
            percentChange.textColor = NSColor(red: (244 / 255), green: (66 / 255), blue: (66 / 255), alpha: 1)
          }
          percentChange.stringValue += String(format: "%.2f%%", percent)
          percentChange.frame.origin.x = card.frame.size.width - 20 - percentChange.stringValue.width(withConstrainedHeight: 20, font: percentChange.font!)
          card.addSubview(percentChange)

          let change = ((autoCompleteData![autoCompleteData!.count - 1 - i] as? NSDictionary)!["regularMarketChange"] as? CGFloat)!

          let priceChange = NSTextField(frame: CGRect(x: 0, y: 35, width: 200, height: 20))
          priceChange.isBezeled = false
          priceChange.isEditable = false
          priceChange.drawsBackground = false
          priceChange.font = NSFont.systemFont(ofSize: 20)
          if change > 0 {
            priceChange.stringValue = "+"
            priceChange.textColor = NSColor(red: (66 / 255), green: (244 / 255), blue: (66 / 255), alpha: 1)
          } else {
            priceChange.textColor = NSColor(red: (244 / 255), green: (66 / 255), blue: (66 / 255), alpha: 1)
          }
          priceChange.stringValue += String(format: "%.2f", change)
          priceChange.frame.origin.x = percentChange.frame.origin.x - 5 - priceChange.stringValue.width(withConstrainedHeight: 20, font: priceChange.font!)
          card.addSubview(priceChange)

          NSAnimationContext.beginGrouping()
          NSAnimationContext.current.duration = 1.0
          card.animator().alphaValue = 1.0
          card.animator().frame.origin.y = y_pos - 75
          NSAnimationContext.endGrouping()

          card.addTrackingArea(NSTrackingArea.init(rect: card.bounds, options: [NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.activeAlways], owner: self, userInfo: nil))

          if y_pos > self.autocompleteView.documentView!.frame.size.height {
            (self.searchBG.subviews.last! as? NSScrollView)!.documentView!.frame.size.height += y_pos
          }

          self.autocompleteView.documentView!.scroll(NSPoint(x: 0, y: self.autocompleteView.documentView!.bounds.size.height))
        }
      } catch {
        print(error.localizedDescription)
      }
    }
  }

  func constructInformationView() {
    informationInfo = NSView(frame: CGRect(x: 0, y: -75, width: self.view.frame.size.width, height: 75))
    informationInfo.wantsLayer = true
    informationInfo.layer!.cornerRadius = 25
    informationInfo.layer!.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    informationInfo.layer!.backgroundColor = NSColor.black.withAlphaComponent(0.65).cgColor
    self.view.addSubview(informationInfo)

    informationInfo.addSubview(NSImageView(frame: CGRect(x: 15, y: 15, width: 100, height: 50)))

    let symbolTitle = NSTextField(frame: CGRect(x: 110, y: 15, width: 250, height: 50))
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

    let typeOfSecurity = NSTextField(frame: CGRect(x: 0, y: 0, width: 0, height: 75))
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
        cell.layer!.backgroundColor = NSColor.lightGray.withAlphaComponent(0.4).cgColor
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
        cell.attribute = indices[counter]
        cell.action = #selector(self.calculateStock(_:))
        cell.isBordered = false
        cell.isTransparent = false
        cell.title = ""
        cell.alphaValue = 0.0
        cell.wantsLayer = true
        cell.layer!.backgroundColor = NSColor.lightGray.withAlphaComponent(0.4).cgColor
        cell.layer!.cornerRadius = 15
        cell.layer!.masksToBounds = true
        self.featuredTickerView.addSubview(cell)

        let iconView = NSImageView(frame: CGRect(x: 10, y: 10, width: 140, height: 80))
        iconView.load(url: featuredIndexIcons[indices[counter]] as! URL)
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
    let autoCompleteData = JSON.readJSONFromFile(fileName: "../../Data/Autocomplete/autocomplete") as? NSArray
    let featuredStockData = JSON.readJSONFromFile(fileName: "../../Data/FeaturedStocks/featuredstocks") as? NSArray
    let featuredIndexData = JSON.readJSONFromFile(fileName: "../../Data/FeaturedIndicies/featuredindicies") as? NSArray
    if StockStructer.mainStock == nil {
      for i in 0..<autoCompleteData!.count {
        if ((autoCompleteData![i] as? NSDictionary)!["symbol"] as? String) == sender.attribute {
          let symbol = ((autoCompleteData![i] as? NSDictionary)!["symbol"] as? String)!
          let fullName = ((autoCompleteData![i] as? NSDictionary)!["longName"] as? String)!
          let regionMarket = ((autoCompleteData![i] as? NSDictionary)!["region"] as? String)! + ":" + ((autoCompleteData![i] as? NSDictionary)!["fullExchangeName"] as? String)!
          let currentPrice = ((autoCompleteData?[i] as? NSDictionary)?["ask"] as? Double) ?? 0.0
          let priceChange = ((autoCompleteData![i] as? NSDictionary)!["regularMarketChangePercent"] as? Double)!
          let percentChange = ((autoCompleteData![i] as? NSDictionary)!["regularMarketChange"] as? Double)!
          
          StockStructer.mainStock = StockStructer(symbol: symbol, fullName: fullName, regionMarket: regionMarket, currentPrice: currentPrice, priceChange: priceChange, percentChange: percentChange)

          break
        }
      }
    }

    if StockStructer.mainStock == nil {
      for i in 0..<featuredStockData!.count {
        if ((featuredStockData![i] as? NSDictionary)!["symbol"] as? String) == sender.attribute {
          let symbol = ((featuredStockData![i] as? NSDictionary)!["symbol"] as? String)!
          let fullName = ((featuredStockData![i] as? NSDictionary)!["longName"] as? String)!
          let regionMarket = ((featuredStockData![i] as? NSDictionary)!["region"] as? String)! + ":" + ((featuredStockData![i] as? NSDictionary)!["fullExchangeName"] as? String)!
          let currentPrice = ((featuredStockData![i] as? NSDictionary)!["ask"] as? Double)!
          let priceChange = ((featuredStockData![i] as? NSDictionary)!["regularMarketChangePercent"] as? Double)!
          let percentChange = ((featuredStockData![i] as? NSDictionary)!["regularMarketChange"] as? Double)!
          StockStructer.mainStock = StockStructer(symbol: symbol, fullName: fullName, regionMarket: regionMarket, currentPrice: currentPrice, priceChange: priceChange, percentChange: percentChange)

          break
        }
      }
    }

    if StockStructer.mainStock == nil {
      for i in 0..<featuredIndexData!.count {
        if ((featuredIndexData![i] as? NSDictionary)!["symbol"] as? String) == sender.attribute {
          let symbol = ((featuredIndexData![i] as? NSDictionary)!["symbol"] as? String)!
          let fullName = ((featuredIndexData![i] as? NSDictionary)!["shortName"] as? String)!
          let regionMarket = ((featuredIndexData![i] as? NSDictionary)!["region"] as? String)! + ":" + ((featuredIndexData![i] as? NSDictionary)!["fullExchangeName"] as? String)!
          let currentPrice = ((featuredIndexData?[i] as? NSDictionary)?["ask"] as? Double) ?? 0.0
          let priceChange = ((featuredIndexData![i] as? NSDictionary)!["regularMarketChangePercent"] as? Double)!
          let percentChange = ((featuredIndexData![i] as? NSDictionary)!["regularMarketChange"] as? Double)!
          StockStructer.mainStock = StockStructer(symbol: symbol, fullName: fullName, regionMarket: regionMarket, currentPrice: currentPrice, priceChange: priceChange, percentChange: percentChange)

          break
        }
      }
    }

    GraphWindowController().showWindow(self)
  }

  func displayFeaturedCellInformation(with mouseLocation: NSPoint) {
    let data = JSON.readJSONFromFile(fileName: "../../Data/FeaturedStocks/featuredstocks")
    for cells in featuredStocksCells {
      for cell in cells {
        if cell.frame.contains(mouseLocation) {
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

  func displayTickerCellInformation(with mouseLocation: NSPoint) {
    let data = JSON.readJSONFromFile(fileName: "../../Data/FeaturedIndicies/featuredindicies")
    for cells in featuredTickerCells {
      for cell in cells {
        if cell.frame.contains(mouseLocation) {
          (informationInfo.subviews[0] as? NSImageView)!.image = (cell.subviews[0] as? NSImageView)!.image
          for i in 0..<(data as? NSArray)!.count {
            let symbol = (((data as? NSArray)![i] as? NSDictionary)!["symbol"] as? String)!
            let regionInfo = (((data as? NSArray)![i] as? NSDictionary)!["region"] as? String)! + " : " + (((data as? NSArray)![i] as? NSDictionary)!["fullExchangeName"] as? String)!
            let fullName = (((data as? NSArray)![i] as? NSDictionary)!["shortName"] as? String)!
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

  func displayInformation(with event: NSEvent) {
    if featuredStocksView.frame.contains(event.locationInWindow) {
      displayFeaturedCellInformation(with: event.locationInWindow.convert(to: featuredStocksView.frame))
    } else if featuredTickerView.frame.contains(event.locationInWindow) {
      displayTickerCellInformation(with: event.locationInWindow.convert(to: featuredTickerView.frame))
    }
  }

  override func mouseEntered(with event: NSEvent) {
    if !inSearchView {
      displayInformation(with: event)

      informationInfo.frame.size.width = self.view.frame.size.width
      informationInfo.subviews[4].frame.origin.x = informationInfo.frame.size.width - 125
      informationInfo.subviews[5].frame.origin.x = informationInfo.frame.size.width - 135
      informationInfo.subviews[6].frame.origin.x = informationInfo.frame.size.width -  80

      informationInfo.subviews[7].frame.size.width = (informationInfo.subviews[7] as? NSTextField)!.stringValue.width(withConstrainedHeight: 75, font: (informationInfo.subviews[7] as? NSTextField)!.font!) + 40
      informationInfo.subviews[7].frame.origin.x = 20 + informationInfo.subviews[4].frame.origin.x - informationInfo.subviews[7].frame.size.width

      NSAnimationContext.beginGrouping()
      NSAnimationContext.current.duration = 1.0
      informationInfo.animator().frame.origin.y = 0
      NSAnimationContext.endGrouping()
    }
  }

  override func mouseExited(with event: NSEvent) {
    NSAnimationContext.beginGrouping()
    NSAnimationContext.current.duration = 0.25
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
