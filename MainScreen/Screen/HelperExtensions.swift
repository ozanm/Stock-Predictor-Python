import Cocoa // Standard MAcOS swift libraries
import QuartzCore // Core Graphics library

public class Cell: NSButton { // An Organizer of the stock buttons

  var attribute : String! // Contains the stock symbol for the comupter to read

  public override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect) // Do the normal thing
  }
}

// Getting releative directory
public let DIRECTORY : String = FileManager.default.currentDirectoryPath

extension String {
  // Inorder to style it, we have to get how tbig the string will be so that they don't overlap
  func width(withConstrainedHeight height: CGFloat, font: NSFont) -> CGFloat {
    let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
    let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

    return ceil(boundingBox.width)
  }
}

extension NSPoint {
  // This takes a point, and sees where it would be in a subview
  func convert(to bounds: NSRect) -> NSPoint {
    return NSPoint(x: self.x - bounds.minX, y: self.y - bounds.minY)
  }
}

extension NSImageView {
  // This loads a image from the specified URL
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

public class Excecute {
  // This is used help run an external script
  public static func execCommand(command: String, args: [String]) {
    let task = Process()
    task.launchPath = command
    task.arguments = args
    do {
      try task.launch()
      task.waitUntilExit()
    } catch {
      print(error.localizedDescription)
    }
  }
}

extension Date {
  // This is used for the graph
  public static func getNumberOfMonths() -> Int {
    let dateComponents = DateComponents(year: Calendar.current.component(.year, from: Date()), month: Calendar.current.component(.month, from: Date()))
    let calendar = Calendar.current
    let date = calendar.date(from: dateComponents)!

    let range = calendar.range(of: .day, in: .month, for: date)!

    return range.count
  }
}

public class JSON {
  // This was used to get the data from the JSON files in the Data folders
  public static func readJSONFromFile(fileName: String) -> Any? {
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
}

extension NSBezierPath {
  // This was a helper function for the animation of the line in the graph
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

public class Point: NSObject {
  // This point class was used in the graph
  public var x: Int!
  public var y: Int!

  public init(x: Int, y: Int) {
    self.x = x
    self.y = y
  }

  // For printing the points to the console
  public override var description: String { return "Point(x: \(self.x!), y: \(self.y!))" }
}

public class Sorter {
  // Sorts an array of Double values into ascending order
  public static func sort(arr: [Double]) -> [Double] {
    var output : [Double] = arr
    for i in 0..<arr.count {
      var minIndex = i
      var minValue = arr[i]
      for j in i..<arr.count {
        if arr[j] < minValue {
          minIndex = j
          minValue = arr[j]
        }
      }

      let temp = output[minIndex]
      output[minIndex] = arr[i]
      output[i] = temp
    }

    return output
  }
}
