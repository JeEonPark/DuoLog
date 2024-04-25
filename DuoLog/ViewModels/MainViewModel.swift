//
//  MainViewModel.swift
//  DuoLog
//
//  Created by DevJonny on 2024/4/17.
//

import SwiftUI
import Firebase
import FirebaseAuth

class MainViewModel: ObservableObject {
    @Published var bubbleDatas: [BubbleData] = []
    @Published var sortedBubbleDatasWithSpaces: [BubbleDataOrSpace] = []
    
    @Published var bubbleDatas2: [BubbleData] = []
    @Published var sortedBubbleDatasWithSpaces2: [BubbleDataOrSpace] = []
    
    // Firebase Firestore 참조
    private let db = Firestore.firestore()
    private var uid = Auth.auth().currentUser?.uid ?? ""
    private var pairUid = ""
    
    func getMyUid() {
        uid = Auth.auth().currentUser?.uid ?? ""
    }
    
    // 나의 pair uid 가져오기
    func getMyPairUid() {
        let docRef = db.collection("Users").document(uid)
        
        docRef.getDocument(completion: { (document, error) in
                if let document = document, document.exists {
                    if let pair = document.data()?["pair"] as? String {
                        self.pairUid = pair
                    } else {
                        print("Pair UID field does not exist or is not a string.")
                    }
                } else {
                    print("Document does not exist")
                }
        })

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let pair = document.data()?["pair"] as? String {
                    self.pairUid = pair
                } else {
                    print("Pair UID field does not exist or is not a string.")
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    // Firebase에서 BubbleComponent 데이터 가져오기
    func fetchBubbleComponents() {
        print("fetchBubbleComponents \(uid)")
        let docRef = db.collection("Users").document(uid)
        docRef.collection("bubbles").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            // documents를 BubbleComponentModel로 변환하여 bubbleComponents에 저장
            self.bubbleDatas = documents.map { queryDocumentSnapshot -> BubbleData in
                let data = queryDocumentSnapshot.data()
                let title = data["title"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let startDate = data["startDate"] as? Timestamp ?? Timestamp()
                let endDate = data["endDate"] as? Timestamp ?? Timestamp()
                let isMine = true
                let gender = 1
                let author = "Jonny"
                return BubbleData(isMine: isMine, gender: gender, title: title, description: description, author: author, startDate: startDate, endDate: endDate)
            }
        }
    }
    
    func fetchBubbleComponents2() {
        print("fetchBubbleCompone2 \(pairUid)")
        db.collection("Users").document(pairUid).collection("bubbles").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            // documents를 BubbleComponentModel로 변환하여 bubbleComponents에 저장
            self.bubbleDatas = documents.map { queryDocumentSnapshot -> BubbleData in
                let data = queryDocumentSnapshot.data()
                let title = data["title"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let startDate = data["startDate"] as? Timestamp ?? Timestamp()
                let endDate = data["endDate"] as? Timestamp ?? Timestamp()
                let isMine = true
                let gender = 2
                let author = "Raon"
                return BubbleData(isMine: isMine, gender: gender, title: title, description: description, author: author, startDate: startDate, endDate: endDate)
            }
        }
        print("ssafdf")
    }
    
    // BubbleData와 빈 시간을 정렬하고 포함하는 배열을 업데이트하는 함수
    func updateSortedBubbleDatasWithSpaces() {
        var sortedBubbleDatasWithSpaces: [BubbleDataOrSpace] = []
        
        // BubbleData 배열을 시간 역순으로 정렬
        let sortedBubbleDatas = bubbleDatas.sorted { $0.startDate.dateValue() > $1.startDate.dateValue() }
        
        // 0 먼저 넣기 (가장 미래의 데이터)
        sortedBubbleDatasWithSpaces.append(BubbleDataOrSpace(isBubbleData: true, bubbleData: sortedBubbleDatas[0], spaceHeight: nil))
        
        for index in 1..<sortedBubbleDatas.count {
            let spaceHeight = (CGFloat(sortedBubbleDatas[index-1].startDate.seconds - sortedBubbleDatas[index].endDate.seconds) / 60 * 3) + 20
            if spaceHeight > 0 {
                sortedBubbleDatasWithSpaces.append(BubbleDataOrSpace(isBubbleData: false, bubbleData: nil, spaceHeight: spaceHeight))
            }
            sortedBubbleDatasWithSpaces.append(BubbleDataOrSpace(isBubbleData: true, bubbleData: sortedBubbleDatas[index], spaceHeight: nil))
        }
        
        self.sortedBubbleDatasWithSpaces = sortedBubbleDatasWithSpaces
    }
    
    func updateSortedBubbleDatasWithSpaces2() {
        var sortedBubbleDatasWithSpaces2: [BubbleDataOrSpace] = []
        
        // BubbleData 배열을 시간 역순으로 정렬
        let sortedBubbleDatas = bubbleDatas2.sorted { $0.startDate.dateValue() > $1.startDate.dateValue() }
        
        // 0 먼저 넣기 (가장 미래의 데이터)
        sortedBubbleDatasWithSpaces2.append(BubbleDataOrSpace(isBubbleData: true, bubbleData: sortedBubbleDatas[0], spaceHeight: nil))
        
        for index in 1..<sortedBubbleDatas.count {
            let spaceHeight = (CGFloat(sortedBubbleDatas[index-1].startDate.seconds - sortedBubbleDatas[index].endDate.seconds) / 60 * 3) + 20
            if spaceHeight > 0 {
                sortedBubbleDatasWithSpaces2.append(BubbleDataOrSpace(isBubbleData: false, bubbleData: nil, spaceHeight: spaceHeight))
            }
            sortedBubbleDatasWithSpaces2.append(BubbleDataOrSpace(isBubbleData: true, bubbleData: sortedBubbleDatas[index], spaceHeight: nil))
        }
        
        self.sortedBubbleDatasWithSpaces2 = sortedBubbleDatasWithSpaces2
    }
    
    // 시간 둘 다 동기화 시키기
    func syncBothBubble() {
        let leftLastStartDate = CGFloat(sortedBubbleDatasWithSpaces.last?.bubbleData?.startDate.seconds ?? 0)
        let rightLastStartDate = CGFloat(sortedBubbleDatasWithSpaces2.last?.bubbleData?.startDate.seconds ?? 0)

        if leftLastStartDate > rightLastStartDate {
            let spaceHeight = ((leftLastStartDate - rightLastStartDate) / 60 * 3) + 20
            sortedBubbleDatasWithSpaces.append(BubbleDataOrSpace(isBubbleData: false, bubbleData: nil, spaceHeight: spaceHeight))
        } else if leftLastStartDate < rightLastStartDate {
            let spaceHeight = ((rightLastStartDate - leftLastStartDate) / 60 * 3) + 20
            sortedBubbleDatasWithSpaces2.append(BubbleDataOrSpace(isBubbleData: false, bubbleData: nil, spaceHeight: spaceHeight))
        }
    }
    
}

struct BubbleData: Identifiable, Hashable {
    var id = UUID() // 식별자 추가
    
    var isMine: Bool
    var gender: Int
    var title: String
    var description: String
    var author: String
    var startDate: Timestamp
    var endDate: Timestamp
}

struct BubbleDataOrSpace: Hashable {
    let isBubbleData: Bool
    let bubbleData: BubbleData?
    let spaceHeight: CGFloat?
}
