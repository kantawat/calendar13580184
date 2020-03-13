
import UIKit
import KDCalendar
import Firebase
import EventKit
import SCLAlertView

class ViewController: UIViewController , CalendarViewDataSource , CalendarViewDelegate{
    
    
    var month = NSDate()
    var fulldayToday = fullDay(date:NSDate())
    var ref: DatabaseReference!

    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var fullDaysLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var spacialDayLabel: UILabel!
    
    @IBOutlet weak var calendarView: CalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        initLabel()
        initCalendarView()
    }
    @IBAction func onSetting(_ sender: Any) {
        performSegue(withIdentifier: "calendartoprofile",sender: self)
//        settingDialog()
    }


    @IBAction func btnActionEventList(_ sender: UIButton) {
        monthEvent = getEventMonth(date: self.month)
        performSegue(withIdentifier: "calendartoList",sender: self)
    }
    
    @IBAction func btnaddEvent(_ sender: UIButton) {
        addEventDialog(ref: self.ref, calendarView: self.calendarView )
    }
    
    func initLabel() {
        spacialDayLabel.text = getEventDay(date: fulldayToday.date)
        daysLabel.text = getdateStrtoformatStr(datestr : fulldayToday.day)
        fullDaysLabel.text = fulldayToday.fulldayStr
        monthLabel.text = "เดือน\(arrShortMonth[fulldayToday.month-1]) \(fulldayToday.year)"
    }
    
    func initCalendarView() {
        let style = CalendarView.Style()
        
        style.cellShape                = .bevel(8.0)
        style.cellColorDefault         = UIColor.clear
        style.cellColorToday           = UIColor(red:1.00, green:0.84, blue:0.64, alpha:1.00)
        style.cellSelectedBorderColor  = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
        style.cellEventColor           = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
        style.headerTextColor          = UIColor.gray
        
        style.cellTextColorDefault     = UIColor(red: 249/255, green: 180/255, blue: 139/255, alpha: 1.0)
        style.cellTextColorToday       = UIColor.orange
        style.cellTextColorWeekend     = UIColor(red: 237/255, green: 103/255, blue: 73/255, alpha: 1.0)
        style.cellColorOutOfRange      = UIColor(red: 249/255, green: 226/255, blue: 212/255, alpha: 1.0)
        
        style.headerBackgroundColor    = UIColor.white
        style.weekdaysBackgroundColor  = UIColor.white
        style.firstWeekday             = .sunday
        
        style.locale                   = Locale(identifier: "en_US")
        
        
        style.cellFont = UIFont(name: "JSChawlewhieng", size: 20.0) ?? UIFont.systemFont(ofSize: 20.0)
        style.headerFont = UIFont(name: "JSChawlewhieng", size: 20.0) ?? UIFont.systemFont(ofSize: 20.0)
        style.weekdaysFont = UIFont(name: "JSChawlewhieng", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
        
        calendarView.style = style
        
        calendarView.dataSource = self
        
        calendarView.delegate = self
        
        calendarView.direction = .horizontal
        calendarView.multipleSelectionEnable = false
        calendarView.marksWeekends = true
        
        
        calendarView.backgroundColor = UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 1.0)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let today = Date()
        #if KDCALENDAR_EVENT_MANAGER_ENABLED
        self.calendarView.loadEvents(calendar: ChineseCalendar) { error in
            if error != nil {
                let message = "The karmadust calender could not load system events. It is possibly a problem with permissions"
                let alert = UIAlertController(title: "Events Loading Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        #endif
        self.calendarView.setDisplayDate(today, animated: false)
        
    }
    
    func startDate() -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.month = -12
        
        let today = Date()
        
        let threeMonthsAgo = self.calendarView.calendar.date(byAdding: dateComponents, to: today)!
        
        return threeMonthsAgo
        
    }
    
    func endDate() -> Date {
        
        var dateComponents = DateComponents()
        
        dateComponents.month = 145
        let today = Date()
        
        let twoYearsFromNow = self.calendarView.calendar.date(byAdding: dateComponents, to: today)!
        
        return twoYearsFromNow
        
    }
    
    
    func headerString(_ date: Date) -> String? {
        return ""
    }
    
    func calendar(_ calendar: CalendarView, didScrollToMonth date: Date) {
        self.month = date as NSDate
        let monthDate = Int(self.month.toString(dateFormat: "MM"))!
        let yearDate = Int(self.month.toString(dateFormat: "yyyy"))! + 543
        monthLabel.text = "\(arrShortMonth[monthDate-1]) พ.ศ \(yearDate)"
        
    }
    
    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
        initDay = date as NSDate
        performSegue(withIdentifier: "detailView",sender: self)
        
    }
    
    func calendar(_ calendar: CalendarView, canSelectDate date: Date) -> Bool {
        return true
    }
    
    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {
        
    }
    
    func calendar(_ calendar: CalendarView, didLongPressDate date: Date, withEvents events: [CalendarEvent]?) {
        
    }
    
}

