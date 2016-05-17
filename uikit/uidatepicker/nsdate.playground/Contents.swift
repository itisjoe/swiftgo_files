//: Playground - noun: a place where people can play

import UIKit

// 簡單的建立了一個目前時間的常數
// 型別為 NSDate
let nowDate = NSDate()

// 你可以使用型別為 NSDate 的常數來對日期時間作處理
// 例如將現在時間加上一天
// dateByAddingTimeInterval 的單位是秒
let oneDayAfter = nowDate.dateByAddingTimeInterval(60 * 60 * 24)

// 現在處理完後
// 如果要將這個 NSDate 常數轉換成字串
// 則是要利用 NSDateFormatter
let formatter = NSDateFormatter()

// 先設置日期時間顯示的格式
formatter.dateFormat = "yyyy-MM-dd HH:mm"

// 再將 oneDayAfter 轉換成字串
let oneDayAfterToString = formatter.stringFromDate(oneDayAfter)

// 印出：明天這一刻的日期時間
print(oneDayAfterToString)

// 或是你要從一個顯示日期時間的字串 轉換成 NSDate
let xmasDate = formatter.dateFromString("2016-12-25 21:30")
// 這時便可以再對這個 NSDate 常數作處理

