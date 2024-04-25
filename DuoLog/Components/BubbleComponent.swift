//
//  BubbleComponent.swift
//  DuoLog
//
//  Created by DevJonny on 2024/4/17.
//

import SwiftUI
import FirebaseFirestore

struct BubbleComponent: View {
    @State var isMine: Bool
    @State var gender: Int
    @State var title: String
    @State var description: String
    @State var author: String
    @State var startDate: Timestamp
    @State var endDate: Timestamp
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.custom("PretendardJP-Medium", size: 16))
                Spacer()
            }
            HStack {
                Text(description)
                    .font(.custom("PretendardJP-Light", size: 14))
                Spacer()
            }
            Spacer()
            HStack {
                Text("\(formatDate(timestamp: startDate))")
                    .font(.custom("PretendardJP-Light", size: 12))
                    .foregroundColor(.black.opacity(0.7))
                Spacer()
                Text(author)
                    .font(.custom("PretendardJP-Light", size: 12))
                    .foregroundColor(.black.opacity(0.5))
            }
            .padding(.top)
        }
        .frame(height: calculateHeight())
        .padding()
        .background(gender == 1 ? Color(hex: 0xC7D7FB) : Color(hex: 0xFEC4B6))
        .cornerRadius(8)
        .padding(.vertical, 10)
    }
    
    private func calculateHeight() -> CGFloat {
        let timeInterval = endDate.dateValue().timeIntervalSince(startDate.dateValue()) // startDate와 endDate의 시간 차이 (초)
        let minutes = Int(timeInterval) / 60 // 분으로 변환
        let calculatedHeight = CGFloat(minutes) * 3 // 분 당 3의 높이를 적용
        return max(calculatedHeight, 90) // 계산된 높이와 90 중에서 큰 값을 반환
    }
    
    private func formatDate(timestamp: Timestamp) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd HH:mm" // 포맷 지정
        return dateFormatter.string(from: timestamp.dateValue()) // Timestamp를 Date로 변환하여 포맷 적용
    }
}

struct BubbleComponent_Previews: PreviewProvider {
    static var previews: some View {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let specificDate = dateFormatter.date(from: "2023-01-20 03:30:00") // 원하는 특정 시간을 Date로 변환

        let startDate = Timestamp(date: specificDate ?? Date()) // 만약 specificDate가 nil이면 현재 시간을 사용
        let endDate = Timestamp(date: specificDate?.addingTimeInterval(1800) ?? Date()) // 현재 시간으로부터 1시간 뒤의 Timestamp를 endDate에 할당
        
        return BubbleComponent(isMine: true, gender: 2, title: "Apple Developer Acadmey", description: "10시까지는 무조건 가기", author: "Jonny", startDate: startDate, endDate: endDate)
    }
}
