//
//  MainView.swift
//  DuoLog
//
//  Created by DevJonny on 2024/4/15.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct MainView: View {
    
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                // MARK: 상단바
                HStack {
                    Image("DuoLog-horizontal")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                    Spacer()
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundColor(Color(hex: 0x464646))
                        
                    })
                    .padding(.horizontal)
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "calendar")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundColor(Color(hex: 0x464646))
                    })
                }
                .padding(.horizontal, 16)
                
                // MARK: 컨텐츠
                ScrollView {
                    VStack {
                        HStack (alignment: .bottom){
                            VStack(spacing: 0) {
                                ForEach(mainViewModel.sortedBubbleDatasWithSpaces, id: \.self) { item in
                                    if item.isBubbleData {
                                        BubbleComponent(isMine: item.bubbleData!.isMine, gender: item.bubbleData!.gender, title: item.bubbleData!.title, description: item.bubbleData!.description, author: item.bubbleData!.author, startDate: item.bubbleData!.startDate, endDate: item.bubbleData!.endDate)
                                    } else {
                                        Spacer()
                                            .frame(height: item.spaceHeight)
                                    }
                                }
                            }
                            VStack(spacing: 0) {
                                ForEach(mainViewModel.sortedBubbleDatasWithSpaces2, id: \.self) { item in
                                    if item.isBubbleData {
                                        BubbleComponent(isMine: item.bubbleData!.isMine, gender: item.bubbleData!.gender, title: item.bubbleData!.title, description: item.bubbleData!.description, author: item.bubbleData!.author, startDate: item.bubbleData!.startDate, endDate: item.bubbleData!.endDate)
                                    } else {
                                        Spacer()
                                            .frame(height: item.spaceHeight)
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal, 16)
            }
            .onAppear {
//                mainViewModel.getMyPairUid()
//                mainViewModel.fetchBubbleComponents()
//                mainViewModel.fetchBubbleComponents2()
                mainViewModel.updateSortedBubbleDatasWithSpaces()
                mainViewModel.updateSortedBubbleDatasWithSpaces2()
                mainViewModel.syncBothBubble()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        // 현재 시간
        let currentDate = Date()
        
        // 가짜 BubbleComponentModel 생성
        let fakeBubbleData1 = BubbleData(isMine: true,
                                         gender: 1,
                                         title: "아카데미 가기",
                                         description: "아카데미 가기",
                                         author: "Jonny",
                                         startDate: Timestamp(date: currentDate.addingTimeInterval(1000)),
                                         endDate: Timestamp(date: currentDate.addingTimeInterval(1800))) // 현재 시간으로부터 30분 뒤
        
        let fakeBubbleData2 = BubbleData(isMine: false,
                                         gender: 1,
                                         title: "친구랑 약속",
                                         description: "친구랑 만나서 학식 먹기",
                                         author: "Jonny",
                                         startDate: Timestamp(date: currentDate.addingTimeInterval(4000)), // 현재 시간으로부터 1시간 뒤
                                         endDate: Timestamp(date: currentDate.addingTimeInterval(7200))) // 현재 시간으로부터 2시간 뒤
        
        let fakeBubbleData3 = BubbleData(isMine: true,
                                         gender: 1,
                                         title: "미용실",
                                         description: "머리 자르러 감",
                                         author: "Jonny",
                                         startDate: Timestamp(date: currentDate.addingTimeInterval(8000)), // 현재 시간으로부터 3시간 뒤
                                         endDate: Timestamp(date: currentDate.addingTimeInterval(12000))) // 현재 시간으로부터 4시간 뒤
        
        let fakeBubbleData4 = BubbleData(isMine: false,
                                         gender: 1,
                                         title: "공부",
                                         description: "iOS 강의 듣고 클론코딩 하나 완성",
                                         author: "Jonny",
                                         startDate: Timestamp(date: currentDate.addingTimeInterval(14000)), // 현재 시간으로부터 5시간 뒤
                                         endDate: Timestamp(date: currentDate.addingTimeInterval(17000))) // 현재 시간으로부터 6시간 뒤
        
        // 상대방 데이터
        let fakeBubbleData5 = BubbleData(isMine: true,
                                         gender: 2,
                                         title: "학교",
                                         description: "학교 수업",
                                         author: "Rina",
                                         startDate: Timestamp(date: currentDate),
                                         endDate: Timestamp(date: currentDate.addingTimeInterval(1800))) // 현재 시간으로부터 30분 뒤

        let fakeBubbleData6 = BubbleData(isMine: false,
                                         gender: 2,
                                         title: "엄마랑 쇼핑",
                                         description: "엄마와 쇼핑하기",
                                         author: "Rina",
                                         startDate: Timestamp(date: currentDate.addingTimeInterval(7200)), // 현재 시간으로부터 1시간 뒤
                                         endDate: Timestamp(date: currentDate.addingTimeInterval(7200+1800))) // 현재 시간으로부터 2시간 뒤

        let fakeBubbleData7 = BubbleData(isMine: true,
                                         gender: 2,
                                         title: "엄마랑 쇼핑",
                                         description: "엄마랑 아뮤에서 쇼핑하기",
                                         author: "Rina",
                                         startDate: Timestamp(date: currentDate.addingTimeInterval(10800)), // 현재 시간으로부터 3시간 뒤
                                         endDate: Timestamp(date: currentDate.addingTimeInterval(15000))) // 현재 시간으로부터 4시간 뒤

        let fakeBubbleData8 = BubbleData(isMine: false,
                                         gender: 2,
                                         title: "TOPIK 공부",
                                         description: "TOPIK 단어 외우기",
                                         author: "Rina",
                                         startDate: Timestamp(date: currentDate.addingTimeInterval(18000)), // 현재 시간으로부터 5시간 뒤
                                         endDate: Timestamp(date: currentDate.addingTimeInterval(21600))) // 현재 시간으로부터 6시간 뒤

        
        let fakeViewModel = MainViewModel()
        fakeViewModel.bubbleDatas = [fakeBubbleData1, fakeBubbleData2, fakeBubbleData3, fakeBubbleData4]
        fakeViewModel.bubbleDatas2 = [fakeBubbleData5, fakeBubbleData6, fakeBubbleData7, fakeBubbleData8]
        
        return MainView(mainViewModel: fakeViewModel)
    }
}
