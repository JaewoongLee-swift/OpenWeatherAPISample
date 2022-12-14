//
//  Weather.swift
//  WeatherAPISample
//
//  Created by 이재웅 on 2022/09/17.
//

import Foundation

struct Weather: Decodable {
    let response: Response
}

struct Response: Decodable {
    let header: Header
    let body: WeatherBody
}

struct Header: Decodable {
    let resultCode: String
    let resultMsg: String
}

struct WeatherBody: Decodable {
    let dataType: String
    let items: WeatherItems
    let pageNo: Int
    let numOfRows: Int
    let totalCount: Int
}

struct WeatherItems: Decodable {
    let item: [WeatherItem]
}

struct WeatherItem: Decodable {
    let baseDate: String
    let baseTime: String
    let category: String
    let fcstDate: String
    let fcstTime: String
    let fcstValue: String
    let nx: Int
    let ny: Int
    
    var categoryName: String {
        return convertCategoryName(self.category)
    }
    
    var categoryValue: String {
        return convertCategoryValue(self.category, self.fcstValue)
    }
    
    var timeValue: String {
        let time = (Int(self.fcstTime) ?? -1) / 100
        
        switch time {
        case 0:
            return "오전 0시"
        case 0..<12:
            return "오전 \(time)시"
        case 12:
            return "오후 12시"
        case 13..<24:
            return "오후 \(time - 12)시"
        default:
            return "시간변환 실패"
        }
    }
    
    private func convertCategoryName(_ category: String) -> String {
        switch category {
        case "POP":
            return "강수확률"
        case "PTY":
            return "강수형태"
        case "PCP":
            return "1시간 강수량"
        case "REH":
            return "습도"
        case "SNO":
            return "1시간 신적설"
        case "SKY":
            return "하늘상태"
        case "TMP":
            return "1시간 기온"
        case "UUU":
            return "풍속(동서성분)"
        case "VVV":
            return "풍속(남북성분)"
        case "WAV":
            return "파고"
        case "VEC":
            return "풍향"
        case "WSD":
            return "풍속"
            
        default:
            return "예보항복 유형 판단오류"
        }
    }
    
    private func convertCategoryValue(_ category: String, _ value: String) -> String {
        switch category {
        case "POP", "REH":
            return "\(value)%"
        case "PTY":
            return convertPrecipitaionFornValue(value)
        case "PCP":
            return convertRainfallValue(value)
        case "SNO":
            return convertSnowValue(value)
        case "SKY":
            return convertSkyCondition(value)
        case "TMP":
            return "\(value)도"
        case "UUU", "VVV", "WSD":
            return "\(value)m/s"
        case "WAV":
            return "\(value)m"
        case "VEC":
            return convertWindDirection(value)
            
        default:
            return "예보항복 유형 판단오류"
        }
    }
    
    private func convertWindDirection(_ value: String) -> String {
        let windDirectionValue = Double(value)!
        let convertedValue = Int((windDirectionValue + (22.5 * 0.5))/22.5)
        
        switch convertedValue {
        case 0, 16:
            return "N"
        case 1:
            return "NNE"
        case 2:
            return "NE"
        case 3:
            return "ENE"
        case 4:
            return "E"
        case 5:
            return "ESE"
        case 6:
            return "SE"
        case 7:
            return "SSE"
        case 8:
            return "S"
        case 9:
            return "SSW"
        case 10:
            return "SW"
        case 11:
            return "WSW"
        case 12:
            return "W"
        case 13:
            return "WNW"
        case 14:
            return "NW"
        case 15:
            return "NNW"
            
        default:
            return "풍향 변환실패"
        }
    }
    
    private func convertSkyCondition(_ value: String) -> String {
        switch value {
        case "1":
            return "맑음"
        case "3":
            return "구름많음"
        case "4":
            return "흐림"
        default:
            return "무언가 내림"
        }
    }
    
    private func convertSnowValue(_ value: String) -> String {
        switch Double(value) ?? -1 {
        case -1:
            return "적설없음"
        case 0..<1:
            return "1cm 미만"
        case 1..<5:
            return "1cm 이상 5cm 미만"
        default:
            return "5cm 이상"
        }
    }
    
    private func convertRainfallValue(_ value: String) -> String {
        switch Int(value) ?? -1 {
        case -1:
            return "강수없음"
        case 0..<1:
            return "1mm 미만"
        case 1..<30:
            return "1mm 이상 30mm 미만"
        case 30..<50:
            return "30~50mm"
        default:
            return "50mm 이상"
        }
    }
    
    private func convertPrecipitaionFornValue(_ value: String) -> String {
        switch Int(value) ?? -1 {
        case 0:
            return "강수없음"
        case 1:
            return "비"
        case 2:
            return "비/눈"
        case 3:
            return "눈"
        case 4:
            return "소나기"
        default:
            return "강수형태 변환오류"
        }
    }
}


