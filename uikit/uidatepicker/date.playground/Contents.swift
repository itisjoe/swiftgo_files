//: Playground - noun: a place where people can play

import UIKit

// 簡單的建立了一個目前時間的常數
// 型別為 Date
let nowDate = Date()

// 你可以使用型別為 Date 的常數來對日期時間作處理
// 例如將現在時間加上一天
// addingTimeInterval 的單位是秒
let oneDayAfter = nowDate.addingTimeInterval(60 * 60 * 24)

// 現在處理完後
// 如果要將這個 Date 常數轉換成字串
// 則是要利用 DateFormatter
let formatter = DateFormatter()

// 先設置日期時間顯示的格式
formatter.dateFormat = "yyyy-MM-dd HH:mm"

// 再利用 DateFormatter 的 string(from:) 方法
// 將 oneDayAfter 轉換成字串
let oneDayAfterToString = formatter.string(from: oneDayAfter)

// 印出：明天這一刻的日期時間
print(oneDayAfterToString)

// 或是你要從一個顯示日期時間的字串 轉換成 Date
let xmasDate = formatter.date(from: "2016-12-25 21:30")
// 這時便可以再對這個 Date 常數作處理

