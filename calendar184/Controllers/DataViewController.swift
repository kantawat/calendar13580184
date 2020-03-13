

import UIKit
import KDCalendar
import Firebase
import EventKit

class DataViewController: UIViewController , CalendarViewDataSource , CalendarViewDelegate{
    
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var calendarView: CalendarView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        calendarView.dataSource = self
        calendarView.delegate = self
//        calendarView.alpha = 0

        
        self.ref = Database.database().reference()
        //
       
            awaitFuncChineseCalendar { (Bool) in
                if(Bool){
                     if(!self.checkChineseCalendar()){
                        for yeardetail in chineseCalendarList {
                            
                            var initDateYear = yeardetail.startDate.toDateTime()
                            for monthdetail in yeardetail.detailMonths {
                                
                                let arrspacialDay = spacialDayList.filter {
                                    ($0 ).monthChinese == Int(monthdetail.nameMonth)
                                }
                                
                                if !arrspacialDay.isEmpty{
                                    for v in arrspacialDay{
                                        let date = initDateYear.addDays(v.dayChinese) as NSDate
                                        self.calendarView.addEvent(calendar: ChineseCalendar,v.name, date: date as Date)
                                    }
                                    initDateYear = initDateYear.addDays(monthdetail.amountDay) as NSDate
                                    
                                }
                                
                            }
                        }
                        
                    }
//                    self.performSegue(withIdentifier: "notfacebook", sender: self)
                    self.performSegue(withIdentifier: "loadDataToLogin",sender: self)
                }
            }
    }
    
    func awaitFuncSpacialDay(completion: @escaping (_ success: Bool) -> Void) {
        awaitFuncBeg { (Bool) in
            if(Bool){
                var itemlist = [spacialDayFire]()
                self.ref.child("Special_Day_Details").observeSingleEvent(of: .value, with: { (snapshot) in
                    //            group.enter()
                    
                    let enumerator = snapshot.children
                    while let rest = enumerator.nextObject() as? DataSnapshot {
                        let newModel = spacialDayFire(dict: rest.value as! [String : AnyObject])
                        itemlist.append(newModel)
                    }
                    
                    spacialDayList = itemlist
                    completion(true)
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
        }
        
    }
    func awaitFuncChineseCalendar(completion: @escaping (_ success: Bool) -> Void) {
        awaitFuncSpacialDay { (Bool) in
            if(Bool){
                var itemlist = [chineseCalendarFire]()
                self.ref.child("chineseCalendar").child(initDate).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let enumerator = snapshot.children
                    while let rest = enumerator.nextObject() as? DataSnapshot {
                        let newModel = chineseCalendarFire(dict: rest.value as! [String : AnyObject])
                        itemlist.append(newModel)
                    }
                    chineseCalendarList = itemlist
                    completion(true)
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func awaitFuncBeg(completion: @escaping (_ success: Bool) -> Void) {
        awaitFuncNotLike { (Bool) in
            if(Bool){
                var itemlist = [Beg]()
                self.ref.child("Day_Details/beg_details").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let enumerator = snapshot.children
                    while let rest = enumerator.nextObject() as? DataSnapshot {
                        let newModel = Beg(dict: rest.value as! [String : AnyObject])
                        itemlist.append(newModel)
                    }
                    
                    begList = itemlist
                    completion(true)
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
        }
        
    }
    
    func awaitFuncNotLike(completion: @escaping (_ success: Bool) -> Void) {
        awaitFuncGoodOrBad { (Bool) in
            if(Bool){
                var itemlist = [NotLike]()
                self.ref.child("Day_Details/not_like_details").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let enumerator = snapshot.children
                    while let rest = enumerator.nextObject() as? DataSnapshot {
                        let newModel = NotLike(dict: rest.value as! [String : AnyObject])
                        itemlist.append(newModel)
                    }
                    
                    notLikeList = itemlist
                    completion(true)
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
        }
        
    }

    func awaitFuncGoodOrBad(completion: @escaping (_ success: Bool) -> Void) {
        var itemlist = [GoodOrBad]()
        self.ref.child("Day_Details/good_bad_day_details").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                let newModel = GoodOrBad(dict: rest.value as! [String : AnyObject])
                itemlist.append(newModel)
            }
            
            goodOrBadList = itemlist
            completion(true)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    func checkChineseCalendar() -> Bool  {
        let eventStore = EKEventStore()
        let calendars = eventStore.calendars(for: .event)
        var check = false
        for calendar in calendars {
            if calendar.title == ChineseCalendar {
                check = true
            }
        }
        
        return check
        
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
        
    }
    
    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
        
    }
    
    func calendar(_ calendar: CalendarView, canSelectDate date: Date) -> Bool {
        return true
    }
    
    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {
        
    }
    
    func calendar(_ calendar: CalendarView, didLongPressDate date: Date, withEvents events: [CalendarEvent]?) {
        
    }
    
    
    
    
}




