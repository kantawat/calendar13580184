
import UIKit
import KDCalendar
import Firebase
import EventKit
import SCLAlertView

func addEventDialog(ref: DatabaseReference , calendarView:CalendarView) {
    
    let appearance = SCLAlertView.SCLAppearance(
        kWindowWidth: screenWidth - 50,
        kTitleFont: UIFont(name: "JSChawlewhieng", size: 20)!,
        kTextFont: UIFont(name: "JSChawlewhieng", size: 14)!,
        kButtonFont: UIFont(name: "JSChawlewhieng", size: 14)!,
        showCloseButton: false
    )
    
    let alert = SCLAlertView(appearance: appearance)
    print("screenWidth : \(screenWidth)")
    print("screenHeight : \(screenHeight)")
    let reactsize = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: screenWidth - 50, height: 250))
    let subview = UIView(frame: reactsize)
    
    let reactsize2 = CGRect(origin: CGPoint(x: subview.center.x - 130 ,y :10), size: CGSize(width: 250, height: 25))
    let textfield1 = UITextField(frame: reactsize2)
    textfield1.layer.borderColor = UIColor.black.cgColor
    textfield1.layer.borderWidth = 0.6
    textfield1.layer.cornerRadius = 5
    textfield1.font = UIFont(name: "JSChawlewhieng", size: 20)!
    textfield1.placeholder = "หัวข้อ"
    textfield1.textAlignment = NSTextAlignment.center
    subview.addSubview(textfield1)
    
    let reactsize3 = CGRect(origin: CGPoint(x: subview.center.x - 130 ,y :textfield1.frame.maxY + 20 ), size: CGSize(width: 250, height: 50))
    let textfield2 = UITextField(frame: reactsize3)
    textfield2.layer.borderColor = UIColor.black.cgColor
    textfield2.layer.borderWidth = 0.6
    textfield2.layer.cornerRadius = 5
    textfield2.font = UIFont(name: "JSChawlewhieng", size: 20)!
    textfield2.placeholder = "เนื้อหา"
    textfield2.textAlignment = NSTextAlignment.center
    subview.addSubview(textfield2)
    
    let reactsize4 = CGRect(origin: CGPoint(x: 20 ,y :textfield2.frame.maxY + 20 ), size: CGSize(width: 200, height: 25))
    let label = UILabel(frame: reactsize4)
    label.font = UIFont(name: "JSChawlewhieng", size: 20)!
    label.text = "วันที่"
    subview.addSubview(label)
    
    
    
    let reactsize5 = CGRect(origin: CGPoint(x: subview.center.x - 150,y :label.frame.maxY + 20), size: CGSize(width: 280, height: 50))
    let datePicker =  UIDatePicker(frame: reactsize5)
    datePicker.datePickerMode = .dateAndTime
    datePicker.timeZone = NSTimeZone.local
    datePicker.backgroundColor = UIColor.white
    
    let calendar = Calendar(identifier: .gregorian)
    var comps = DateComponents()
    comps.month = 1
    let maxDate = calendar.date(byAdding: comps, to: Date())
    comps.month = 0
    comps.day = -1
    let minDate = calendar.date(byAdding: comps, to: Date())
    datePicker.maximumDate = maxDate
    datePicker.minimumDate = minDate
    subview.addSubview(datePicker)
    
    alert.customSubview = subview
    alert.addButton("Save") {
        let mili = getCurrentMillis(date: datePicker.date)
        let title = textfield1.text ??  ""
        let subtile = textfield2.text ??  ""
        
        let eventCus = eventCustom(date: datePicker.date as NSDate, title:title ,subtile:subtile)
        
        let obj = ["date": eventCus.date,
                   "title": eventCus.title,
                   "subtile": eventCus.subtile]
        
        ref.child("users").child("\(userUid)/notes/\(mili)").setValue(obj)
        
        calendarView.addEvent(calendar: ChineseCalendar,eventCus.title, date: datePicker.date as Date)
    }
    alert.addButton("Cancel") {}
    
    //        alert.addButton("Duration Button", backgroundColor: UIColor.brown, textColor: UIColor.yellow) {}
    
    alert.showInfo("Add event", subTitle: "")
}

func settingDialog() {
    
    let appearance = SCLAlertView.SCLAppearance(
        kCircleIconHeight: 50, kWindowWidth: screenWidth - 50,
        kTitleFont: UIFont(name: "JSChawlewhieng", size: 28)!,
        kTextFont: UIFont(name: "JSChawlewhieng", size: 20)!,
        kButtonFont: UIFont(name: "JSChawlewhieng", size: 20)!,
        showCloseButton: false
    )
    
    let alert = SCLAlertView(appearance: appearance)
    let reactsize = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: screenWidth - 50, height: 250))
    let subview = UIView(frame: reactsize)
    
    
    let reactsize4 = CGRect(origin: CGPoint(x: 20 ,y : 20 ), size: CGSize(width: 200, height: 25))
    let label = UILabel(frame: reactsize4)
    label.font = UIFont(name: "JSChawlewhieng", size: 20)!
    label.text = "Setting"
    subview.addSubview(label)
    
    
    
    let reactsize5 = CGRect(origin: CGPoint(x: subview.center.x - 150,y :label.frame.maxY + 20), size: CGSize(width: 280, height: 50))
    let datePicker =  UIDatePicker(frame: reactsize5)
    datePicker.datePickerMode = .dateAndTime
    datePicker.timeZone = NSTimeZone.local
    datePicker.backgroundColor = UIColor.white
    
    let calendar = Calendar(identifier: .gregorian)
    var comps = DateComponents()
    comps.month = 1
    let maxDate = calendar.date(byAdding: comps, to: Date())
    comps.month = 0
    comps.day = -1
    let minDate = calendar.date(byAdding: comps, to: Date())
    datePicker.maximumDate = maxDate
    datePicker.minimumDate = minDate
    subview.addSubview(datePicker)
    
    alert.customSubview = subview
    alert.addButton("Log out") {
    }
    alert.addButton("save") {}
    alert.addButton("done") {}
    
    //        alert.addButton("Duration Button", backgroundColor: UIColor.brown, textColor: UIColor.yellow) {}
    
    var image: UIImage?
    let url = NSURL(string: userPic)! as URL
    if let imageData: NSData = NSData(contentsOf: url) {
        image = UIImage(data: imageData as Data)
    }
    
    alert.showInfo(userFullname, subTitle: "", circleIconImage: makeRoundImg(image: image!))
}
