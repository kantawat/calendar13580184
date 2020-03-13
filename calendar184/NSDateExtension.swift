
import Foundation
import UIKit
import QuartzCore

extension NSDate {
    func isBetweeen(date date1: NSDate, andDate date2: NSDate) -> Bool {
        return date1.compare(self as Date) == self.compare(date2 as Date)
    }
    
    
    func getDays() -> Int {
        let days = Calendar.current.dateComponents([.day], from: self as Date )
        return days.day!
    }
    func getMonth() -> Int {
        let months = Calendar.current.dateComponents([.month], from: self as Date )
        return months.month!
    }
    func getYear() -> Int {
        let years = Calendar.current.dateComponents([.year], from: self as Date )
        return years.year!
    }
    
    func addDays(_ x: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: x, to: self as Date)!
    }
    func addMonth(_ x: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: x, to: self as Date)!
    }
    func addYear(_ x: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: x, to: self as Date)!
    }
    func xWeeks(_ x: Int) -> Date {
        return Calendar.current.date(byAdding: .weekOfYear, value: x, to: self as Date)!
    }
   
    
    func toString(dateFormat format  : String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let myString = formatter.string(from: self as Date)
        
        return myString
    }
    
}



extension String
{
    func toDateTime() -> NSDate
    {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let dateFromString : NSDate = dateFormatter.date(from: self)! as NSDate
        
        return dateFromString
    }
    
}


func makeRoundImg(image: UIImage) -> UIImage {
    var imageView = UIImageView(image: image)
    let imgLayer = CALayer()
    imgLayer.frame = imageView.bounds
    imgLayer.contents = imageView.image?.cgImage;
    imgLayer.masksToBounds = true;
    
    imgLayer.cornerRadius = imageView.frame.size.width/2
    
    UIGraphicsBeginImageContext(imageView.bounds.size)
    imgLayer.render(in: UIGraphicsGetCurrentContext()!)
    let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return roundedImage!;
}
