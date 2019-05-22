import Cocoa
import QuartzCore

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

extension NSPoint {
  func convert(to bounds: NSRect) -> NSPoint {
    return NSPoint(x: self.x - bounds.minX, y: self.y - bounds.minY)
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

public class Excecute {
  public static func execCommand(command: String, args: [String]) {
    let autoCompleteTask = Process()
    autoCompleteTask.launchPath = command
    autoCompleteTask.arguments = args
    do {
      try autoCompleteTask.launch()
    } catch {
      print(error.localizedDescription)
    }
  }
}

extension Date {
  public static func getNumberOfMonths() -> Int {
    let dateComponents = DateComponents(year: Calendar.current.component(.year, from: Date()), month: Calendar.current.component(.month, from: Date()))
    let calendar = Calendar.current
    let date = calendar.date(from: dateComponents)!

    let range = calendar.range(of: .day, in: .month, for: date)!

    return range.count
  }
}

public class JSON {
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
  public var x: Int!
  public var y: Int!

  public init(x: Int, y: Int) {
    self.x = x
    self.y = y
  }

  public override var description: String { return "Point(x: \(self.x!), y: \(self.y!))" }
}

public class Sorter {
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
