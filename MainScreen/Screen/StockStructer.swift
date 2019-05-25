public class StockStructer {

  // System for organizing stock data
  // mainStock static var is used for transporting data between controllers

  public static var mainStock : StockStructer!

  // Quote Information from Yahoo! Datacenter
  private var symbol : String!
  private var fullName : String!
  private var regionMarket : String!
  private var currentPrice : Double!
  private var priceChange : Double!
  private var percentChange : Double!

  public init(symbol: String, fullName: String, regionMarket: String, currentPrice: Double, priceChange: Double, percentChange: Double) {
    self.symbol = symbol
    self.fullName = fullName
    self.regionMarket = regionMarket
    self.currentPrice = currentPrice
    self.priceChange = priceChange
    self.percentChange = percentChange
  }

  // ACCESSORS

  public func getSymbol() -> String {
    return self.symbol
  }

  public func getFullName() -> String {
    return self.fullName
  }

  public func getRegionMarket() -> String {
    return self.regionMarket
  }

  public func getCurrentPrice() -> Double {
    return self.currentPrice
  }

  public func getPriceChange() -> Double {
    return self.priceChange
  }

  public func getPercentChange() -> Double {
    return self.percentChange
  }

  // SETTERS

  public func setSymbol(to symbol: String) {
    self.symbol = symbol
  }

  public func setFullName(to fullName: String) {
    self.fullName = fullName
  }

  public func setRegionMarket(to regionMarket: String) {
    self.regionMarket = regionMarket
  }

  public func setCurrentPrice(to currentPrice: Double) {
    self.currentPrice = currentPrice
  }

  public func setPriceChange(to priceChange: Double) {
    self.priceChange = priceChange
  }

  public func setPercentChange(to percentChange: Double) {
    self.percentChange = percentChange
  }
}
