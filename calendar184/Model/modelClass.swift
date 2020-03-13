

import Foundation
import  UIKit
import EventKit



var initDate = "05-02-2019"
var userUid = ""
var userFullname = ""
var userPic = "https://www.matichon.co.th/wp-content/uploads/2019/03/Pic-Little-Wild_190308_0021.jpg"
var searchMap = ""
var initDay =  NSDate()
var ChineseCalendar = "ChineseCalendar" //ChineseCalendar
var spacialDayList = [spacialDayFire]()
var chineseCalendarList = [chineseCalendarFire]()
var begList = [Beg]()
var notLikeList = [NotLike]()
var goodOrBadList = [GoodOrBad]()
var monthEvent = monthEventDetail(month: "",events: [])

let arrMonth = ["มกราคม","กุมภาพันธ์","มีนาคม","เมษายน","พฤษภาคม","มิถุนายน",
                "กรกฎาคม","สิงหาคม","กันยายน","ตุลาคม","พฤศจิกายน","ธันวาคม"]
let arrShortMonth = ["ม.ค.","ก.พ.","มี.ค.","เม.ย.","พ.ค.","มิ.ย.",
                "ก.ค.","ส.ค.","ก.ย","ต.ค.","พ.ย.","ธ.ค."]
let arrWeekDay = ["อาทิตย์","จันทร์","อังคาร","พุธ","พฤหัสบดี","ศุกร์","เสาร์"]

class fullDay : NSObject {
    var date:NSDate
    var day:Int
    var weekDay:Int
    var month:Int
    var year:Int
    var fulldayStr:String = ""
    var sub1dayStr:String = ""
    var sub2dayStr:String = ""
    init(date: NSDate) {
        self.date = date
        self.day = Int(date.toString(dateFormat: "dd"))!
        self.weekDay = Int(date.toString(dateFormat: "e"))!
        self.month = Int(date.toString(dateFormat: "MM"))!
        self.year = Int(date.toString(dateFormat: "yyyy"))! + 543
        self.fulldayStr = "วัน\(arrWeekDay[weekDay-1]) ที่ \(day) \(arrMonth[month-1]) \(year)"
        self.sub1dayStr = "วัน\(arrWeekDay[weekDay-1]) ที่ \(day)"
        self.sub2dayStr = "\(arrMonth[month-1]) \(year)"
    }
    
}

class dayChinsesShow : NSObject {
    var date:NSDate
    var day:String = ""
    var month:String = ""
    var year:String = ""
    var thaiyear:String = ""
    var fulldayStr:String = ""
    var sub1dayStr:String = ""
    var sub2dayStr:String = ""
    var notlike1:String = ""
    var notlike2:String = ""
    var goodbad:String = ""
    var goodbadtype:String = ""
    var spacials = [spacialDayFire]()
    init(date: NSDate , day:String,month:String,year:String,thaiyear:String) {
        self.date = date
        self.day = day
        self.month = month
        self.year = year
        self.thaiyear = thaiyear
        self.fulldayStr = fullDay(date: date).fulldayStr
        self.sub1dayStr = fullDay(date: date).sub1dayStr
        self.sub2dayStr = fullDay(date: date).sub2dayStr
        
        var moredetail = getDetailDay(date: date)
        self.notlike1 = moredetail[0]
        self.notlike2 = moredetail[1]
        self.goodbad = moredetail[2]
        self.goodbadtype = moredetail[3]
        
        self.spacials = spacialDayList.filter {
            (($0 ).monthChinese == Int(month)) && (($0 ).dayChinese == Int(day))
        }
    }
    
}

class eventCustom : NSObject {
    var date:String = ""
    var title:String = ""
    var subtile:String = ""
    init(date: NSDate,title:String,subtile:String) {
        self.date = date.toString(dateFormat: "dd/MM/yyyy hh:mm:ss")
        self.subtile = title
        self.title = subtile
    }
    
}
class monthEventDetail : NSObject {
    var month:String = ""
    var events:[eventDetail]
    init(month:String , events: [eventDetail]) {
        self.month = month
        self.events = events
    }
    
}
class eventDetail : NSObject {
    var title:String = ""
    var dateFullstr:String = ""
    var date:NSDate
    init(title:String ,dateFullstr:String, date: NSDate) {
        self.title = title
        self.dateFullstr = dateFullstr
        self.date = date
    }
}
class spacialDayFire : NSObject {
    var name:String
    var dayChinese:Int
    var detail:[Int]
    var monthChinese:Int
    var image:String = ""
    init(dict: [String: AnyObject]) {
        dayChinese = dict["day_chinese"] as! Int
        name = dict["chinese_event_name"] as! String
        monthChinese = dict["month_chinese"] as! Int
        image = dict["image"] as!String
        
        var list = [Int]()
        if((dict["day_details"]) != nil){
            let enumerator =  dict["day_details"] as! NSArray
            for x in enumerator{
                list.append(x as! Int)
            }
            
        }
        detail = list
        
    }
}

class DetailMonth : NSObject {
    var nameMonth:String
    var amountDay:Int
    init(dict: [String: AnyObject]) {
        nameMonth = dict["nameMonth"] as! String
        amountDay = dict["amountDay"] as! Int
    }
}
class chineseCalendarFire : NSObject {
    var nameYear:String
    var nameChineseYear:String
    var nameThaiYear:String
    var amountMonth:Int
    var amountDays:Int
    var startDate:String
    var endDate:String
    var detailMonths:[DetailMonth]
    init(dict: [String: AnyObject]) {
        nameYear = dict["nameYear"] as! String
        nameThaiYear = dict["nameThaiYear"] as! String
        nameChineseYear = dict["nameChineseYear"] as! String
        amountMonth = dict["amountMonth"] as! Int
        amountDays = dict["amountDays"] as! Int
        startDate = dict["startDate"] as! String
        endDate = dict["endDate"] as! String
        
        var list = [DetailMonth]()
        let enumerator =  dict["detailMonth"] as! NSArray
        for x in enumerator{
            let detailMonth = DetailMonth(dict: x as! [String : AnyObject])
            list.append(detailMonth)
        }
        detailMonths = list
    }
}

class Beg : NSObject {
    var name:String
    var details:[BegDetail]
    init(dict: [String: AnyObject]) {
        name = dict["beg_name"] as! String
        
        var list = [BegDetail]()
        let enumerator =  dict["beg_sub_details"] as! NSArray
        for x in enumerator{
            let beglist = BegDetail(dict: x as! [String : AnyObject])
            list.append(beglist)
        }
        details = list
    }
}
class BegDetail : NSObject {
    var name:String
    var list:[Beglist]
    init(dict: [String: AnyObject]) {
        name = dict["beg_name_item"] as! String
        
        var list = [Beglist]()
        let enumerator =  dict["item_list"] as! NSArray
        for x in enumerator{
            let beglist = Beglist(dict: x as! [String : AnyObject])
            list.append(beglist)
        }
        self.list = list
    }
}
class Beglist : NSObject {
    var name:String
    var img:String
    init(dict: [String: AnyObject]) {
        name = dict["name_item"] as! String
        img = dict["img_item"] as! String
    }
}

class GoodOrBad : NSObject {
    var name:String
    var type:String
    init(dict: [String: AnyObject]) {
        name = dict["GB_name"] as! String
        type = dict["day_type"] as! String
    }
}
class NotLike : NSObject {
    var year1:NotLikeYear
    var year2:NotLikeYear
    init(dict: [String: AnyObject]) {
        year1 = NotLikeYear(dict: dict["NK_frist_year"] as! [String : AnyObject])
        year2 = NotLikeYear(dict: dict["NK_second_year"] as! [String : AnyObject])
    }
}

class NotLikeYear : NSObject {
    var nameEng:String
    var nameThai:String
    init(dict: [String: AnyObject]) {
        nameEng = dict["nameEng"] as! String
        nameThai = dict["nameThai"] as! String
    }
}
