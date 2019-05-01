import AppKit

class MainViewController : NSViewController, NSTextFieldDelegate {

  var gradientBackground : CAGradientLayer!

  var searchBtn : NSButton!
  var searchBG : NSVisualEffectView!

  let exitImage : URL = URL(string: "https://i.imgur.com/dXsQi65.png")!
  let searchImage : URL = URL(string: "https://i.imgur.com/LFsO6Dk.png")!

  var informationInfo : NSView!

  var featuredStocksView : NSView!
  let featuredStocksCells = [[NSButton(frame: NSRect(x: 10, y: 005, width: 160, height: 100)), NSButton(frame: NSRect(x: 180, y: 005, width: 160, height: 100))],
                             [NSButton(frame: NSRect(x: 10, y: 115, width: 160, height: 100)), NSButton(frame: NSRect(x: 180, y: 115, width: 160, height: 100))],
                             [NSButton(frame: NSRect(x: 10, y: 225, width: 160, height: 100)), NSButton(frame: NSRect(x: 180, y: 225, width: 160, height: 100))],
                             [NSButton(frame: NSRect(x: 10, y: 335, width: 160, height: 100)), NSButton(frame: NSRect(x: 180, y: 335, width: 160, height: 100))]]
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
  let featuredTickerCells = [[NSButton(frame: NSRect(x: 10, y: 005, width: 160, height: 100)), NSButton(frame: NSRect(x: 180, y: 005, width: 160, height: 100))],
                             [NSButton(frame: NSRect(x: 10, y: 115, width: 160, height: 100)), NSButton(frame: NSRect(x: 180, y: 115, width: 160, height: 100))],
                             [NSButton(frame: NSRect(x: 10, y: 225, width: 160, height: 100)), NSButton(frame: NSRect(x: 180, y: 225, width: 160, height: 100))],
                             [NSButton(frame: NSRect(x: 10, y: 335, width: 160, height: 100)), NSButton(frame: NSRect(x: 180, y: 335, width: 160, height: 100))]]

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
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do view setup here.

    self.displaySearchBtn()
    self.displayFeaturedStocks()
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
    searchBtn.layer!.backgroundColor = NSColor(red: (40 / 255), green: (45 / 255), blue: (51 / 255), alpha: 1).cgColor
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
    searchBG = NSVisualEffectView(frame: self.view.bounds)
    searchBG.material = .ultraDark
    searchBG.wantsLayer = true
    searchBG.layer!.cornerRadius = 35
    searchBG.layer!.maskedCorners = [.layerMaxXMaxYCorner]
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
      let exitBtn = NSButton(frame: CGRect(x: self.self.view.bounds.size.width - 60, y: self.self.view.bounds.size.height - 60, width: 35, height: 35))
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
      exitBtn.animator().frame.origin.y -= 50
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
    informationInfo = NSView(frame: CGRect(x: self.view.frame.size.width + 200, y: 0, width: 200, height: 200))
    informationInfo.wantsLayer = true
    informationInfo.layer!.backgroundColor = NSColor.black.cgColor
    informationInfo.layer!.cornerRadius = 25
    informationInfo.layer!.maskedCorners = [.layerMinXMaxYCorner]
    self.view.addSubview(informationInfo)

    informationInfo.addSubview(NSImageView(frame: CGRect(x: 75, y: 25, width: 50, height: 50)))
  }

  func displayFeaturedStocks() {
    featuredStocksView = NSView(frame: CGRect(x: 100, y: 75, width: 350, height: 500))
    let featuredStocksTTL = NSTextField(frame: CGRect(x: 0, y: 455, width: 350, height: 45))
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
    let featuredTickerTTL = NSTextField(frame: CGRect(x: 0, y: 455, width: 350, height: 45))
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

    NSAnimationContext.beginGrouping()
    NSAnimationContext.current.duration = 1.0
    featuredStocksTTL.animator().alphaValue = 1.0
    featuredTickerTTL.animator().alphaValue = 1.0
    NSAnimationContext.endGrouping()

    displayFeaturedStocksCells()
  }

  func displayFeaturedStocksCells() {
    var counter = 0
    for sub_cells in featuredStocksCells {
      for cell in sub_cells {
        cell.isBordered = false
        cell.isTransparent = false
        cell.action = #selector(self.calculateStock(_:))
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

  @objc func calculateStock(_ sender: NSButton!) {
    (informationInfo.subviews[0] as? NSImageView)!.image = (sender.subviews[0] as? NSImageView)!.image

    let task = Process()
    task.launchPath = "/usr/bin/python3"
    task.arguments = ["conda activate && python ../../Data/FeaturedStocks/fetch_featured_stocks.py"]
    task.launch()
    task.waitUntilExit()

    let data = readJSONFromFile(fileName: "../../Data/FeaturedStocks/featuredstocks.json")
    print(data)
  }

  func getFeaturedStockData() {

  }

  override func mouseEntered(with event: NSEvent) {
    if featuredStocksView.frame.contains(event.locationInWindow) {
      animateBackground(topColor: NSColor(red: (227 / 255), green: (122 / 255), blue: (92 / 255), alpha: 1),
                        bottomColor: NSColor(red: (190 / 255), green: (132 / 255), blue: (152 / 255), alpha: 1),
                        fillMode: .forwards)
      NSAnimationContext.beginGrouping()
      NSAnimationContext.current.duration = 1.0
      informationInfo.animator().frame.origin.x = self.view.frame.size.width - 200
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
    informationInfo.animator().frame.origin.x = self.view.frame.size.width + 200
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
