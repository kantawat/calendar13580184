/*
 * EventsLoader.swift
 * Created by Michael Michailidis on 26/10/2017.
 * http://blog.karmadust.com/
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */
#if KDCALENDAR_EVENT_MANAGER_ENABLED
import Foundation
import EventKit

enum EventsManagerError: Error {
    case Authorization
}

open class EventsManager {
    
    private static let store = EKEventStore()
    
    static func load(calendar ChineseCalendar:String,from fromDate: Date, to toDate: Date, complete onComplete: @escaping ([CalendarEvent]?) -> Void) {
        
        let q = DispatchQueue.main
        
        guard EKEventStore.authorizationStatus(for: .event) == .authorized else {
            
            return EventsManager.store.requestAccess(to: EKEntityType.event, completion: {(granted, error) -> Void in
                guard granted else {
                    return q.async { onComplete(nil) }
                }
                EventsManager.fetch(calendar: ChineseCalendar,from: fromDate, to: toDate) { events in
                    q.async { onComplete(events) }
                }
            })
        }
        
        EventsManager.fetch(calendar: ChineseCalendar,from: fromDate, to: toDate) { events in
            q.async { onComplete(events) }
        }
    }
    static func CreateCalendar(calendar ChineseCalendar:String) -> Bool{
        let newCalendar = EKCalendar(for: .event, eventStore: store)
        newCalendar.title = ChineseCalendar
        let sourcesInEventStore = store.sources
        newCalendar.source = sourcesInEventStore.filter{
            (source: EKSource) -> Bool in
            source.sourceType.rawValue == EKSourceType.local.rawValue
            }.first!
        do {
            try store.saveCalendar(newCalendar, commit: true)
            return true
        } catch {return false}
    }
    static func add(calendar ChineseCalendar:String,event calendarEvent: CalendarEvent) -> Bool {
        
        guard EKEventStore.authorizationStatus(for: .event) == .authorized else {
            return false
        }
        
        var check = true
        var ca  = store.defaultCalendarForNewEvents
        let calendars = store.calendars(for: .event)
        
        for calendar in calendars {
            if calendar.title == ChineseCalendar {
                ca = calendar
                check = false
            }
            
        }
        if(check){
            if(CreateCalendar(calendar: ChineseCalendar)){
                let calendars = store.calendars(for: .event)
                for calendar in calendars {
                    if calendar.title == ChineseCalendar {
                        ca = calendar
                    }
                    
                }
            }
        }
        
        
        let secondsFromGMTDifference = TimeInterval(TimeZone.current.secondsFromGMT()) * -1
        
        let event = EKEvent(eventStore: store)
        event.title = calendarEvent.title
        event.startDate = calendarEvent.startDate.addingTimeInterval(secondsFromGMTDifference)
        event.endDate = calendarEvent.endDate.addingTimeInterval(secondsFromGMTDifference)
        event.calendar = ca
        //        event.calendar = store.defaultCalendarForNewEvents
        do {
            try store.save(event, span: .thisEvent)
            return true
        } catch {
            return false
        }
    }
    
    private static func fetch(calendar ChineseCalendar:String, from fromDate: Date, to toDate: Date, complete onComplete: @escaping ([CalendarEvent]) -> Void) {
        let calendars = store.calendars(for: .event)
        
        for calendar in calendars {
            if calendar.title == ChineseCalendar {
                
                let predicate = store.predicateForEvents(withStart: fromDate, end: toDate, calendars: [calendar])
                
                let secondsFromGMTDifference = TimeInterval(TimeZone.current.secondsFromGMT())
                
                let events = store.events(matching: predicate).map {
                    return CalendarEvent(
                        title:      $0.title,
                        startDate:  $0.startDate.addingTimeInterval(secondsFromGMTDifference),
                        endDate:    $0.endDate.addingTimeInterval(secondsFromGMTDifference)
                    )
                }
                
                onComplete(events)
            }
        }
        
        //        let predicate = store.predicateForEvents(withStart: fromDate, end: toDate, calendars: nil)
        //
        //        let secondsFromGMTDifference = TimeInterval(TimeZone.current.secondsFromGMT())
        //
        //        let events = store.events(matching: predicate).map {
        //            return CalendarEvent(
        //                title:      $0.title,
        //                startDate:  $0.startDate.addingTimeInterval(secondsFromGMTDifference),
        //                endDate:    $0.endDate.addingTimeInterval(secondsFromGMTDifference)
        //            )
        //        }
        //
        //        onComplete(events)
    }
}
#endif
