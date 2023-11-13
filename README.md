# 소개
> 사용자 상품 등록 및 열람과 실시간 채팅이 가능한 당근 마켓 프로젝트

# 스크린샷
<img src= "https://github.com/DONG-WOON/Karrot-market-clone-coding/assets/80871083/c5e68b74-021d-4b62-ac85-1875c0ecd7c1" width = 180>
<img src= "https://github.com/DONG-WOON/Karrot-market-clone-coding/assets/80871083/72483e68-90b9-4929-8f9b-bc1ee13830ec" width = 180>
<img src= "https://github.com/DONG-WOON/Karrot-market-clone-coding/assets/80871083/97914c9e-109e-45c7-828f-5630f9a2e2c6" width = 180>
<img src= "https://github.com/DONG-WOON/Karrot-market-clone-coding/assets/80871083/4eab148a-2078-40d9-84ee-368e6b6f4eea" width = 180>
<img src= "https://github.com/DONG-WOON/Karrot-market-clone-coding/assets/80871083/b812c7e4-1d50-4f8d-a3fb-cb3b92b386a6" width = 180>

# 프로젝트 기간

- 22.07.10 ~ 22.10.18 (3개월)
- 팀구성: 서동운, ehd

# 프로젝트 내 역할

1. 홈 화면 구현
2. 물품 상세페이지 구현  
3. 검색 화면 구현 
4. CLLocationManager와 Mapkit을 사용한 현재 위치 주변정보 저장기능 및 화면 구현
5. 라우터 패턴을 활용한 Alamofire 라이브러리 추상화
6. 소켓통신을 사용하여 실시간 채팅 구현

# 기술

- MVVM
- UIKit
- MapKit
- Alamofire, Kingfisher
- StompClientLib
- PhotosUI
- FirebaseCloudMessaging, UNUserNotificationCenter

# 주요 기능

1. 중고거래 게시글 사진 등록 및 위치기반 중고 물품 리스트 보기 가능
2. 중고거래 사용자와 실시간 채팅 가능
3. 상세페이지에서 관심물품으로 등록 가능
4. 개인 페이지에서 관심목록, 판매목록 확인 가능
5. 사용자 이미지, 닉네임 설정 및 변경 가능

# 핵심 경험

### ✅ 홈화면 네트워크 통신 프레임 기반 페이지네이션 적용

- 방대한 데이터 fetch를 방지하기 위해 페이지네이션 기반 네트워크 통신 구현
- 사용자 경험을 고려하여 **hitch** 발생 가능성 줄일 수 있음

### ✅ MVVM 아키텍처 적용

- 앱의 비즈니스 로직과 UI를 분리, 응집도 향상

### ✅ *UITableViewDiffableDataSource*

- ViewModel의 데이터를 인덱스가 아닌 모델의 식별자 기반으로 작업하여 안정성 증가
- 코드의 간결성과 가독성을 향상

### ✅ 사용자의 위치정보 실시간 업데이트 제공 시스템 리소스 최적화

- 사용자의 기기 위치 정보를 저장하고, Energy Efficiency Guide for iOS Apps의 Location 관련 정보를 바탕으로 최적화 설정을 적용하여 위치 기반 서비스를 보다 효율적으로 제공
    
    ```swift
    // **사용하지 않을 때 위치 서비스 중지하기**
    self.locationManager.stopUpdatingLocation()
    
    **// 가능한 경우에는 표준 위치 업데이트의 정확도를 낮추기**
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    ```
    

### ✅ 라우터 패턴을 활용한 Alamofire 라이브러리 추상화

- URLRequestConvertible ****프로토콜을 채택하여 네트워크 통신 API를 목적별로 enum 타입을 생성하여 직관적인 코드 가독성을 확보
    
    ```swift
    protocol Requestable: URLRequestConvertible {
        var baseUrl: String { get }
        var header: RequestHeaders { get }
        var path: String { get }
        var parameters: RequestParameters { get }
    }
    enum Purpose: Requestable {
        case login(User)
        case fetchUser(ID)
        case registerUser
        case update(User)
        ...
    }
    typealias ID = String
    ```
    

### ✅ Push Notification

- FCM(Firebase Cloud Messaging)을 이용하여 Push Notification을 구현
- 앱에서 제공하는 채팅 알림 기능을 제공

### ✅ Swift Concurrency (async / await)

- swift 5.5에 도입된 `async / await`을 적용, 기존의 비동기 작업 코드간결화 및 가독성 향상

# 고민한 점

1. **데이터 전달 방식 결정**
    
    Delegate 패턴, Closure 패턴, Notification 패턴 등을 고려하여 데이터 전달 방식을 결정하였습니다. Notification을 지나치게 사용할 경우, 특정 씬에서 감시해야 하는 Notification이 너무 많아질 수 있으므로 역할 분배와 메모리 차원에서 고려해야 합니다. 그러나 여러 씬에서 같은 액션을 취해야 하는 작업의 경우 Notification을 사용했습니다.
    
2. TableView **작업의 복잡성 해결**
    - TableView를 사용할 때, ViewController에서 처리해야하는 작업이 많아져서 복잡해지는 문제를 MVVM 아키텍처를 적용하여 해결하였습니다.
3. **외부에서 다른 객체의 변수에 접근할 때의 문제**
    - 외부에서 접근해서 변경이 필요하지 않은 변수는 `private`으로 선언하고, 외부에서 접근은 가능하지만 수정은 불가능하게 `private(set)` 으로 선언했습니다.
4. **하드코딩 줄이기**
    - 객체명이나 반복되는 텍스트 등을 객체 내부에 하드코딩하지 않고, 네임스페이스를 설정하여 인스턴스 생성을 방지하였습니다. 또한, enum 타입으로 선언하여 코드 가독성을 높였습니다.
5. **네트워크 통신 API 구현시 에러핸들링**
    - do-catch나 throw 에러핸들링 대신 Result Type을 사용하여 코드 간결성을 높였습니다.
6. **필수 UI가 아닌 경우 처리**
    - 모든 사용자에게 필수적이지 않은 UI는 `lazy` 변수로 선언하여 메모리 효율을 높였습니다.

# 회고 및 아쉬운 점

- 기존의 MVC 아키텍처로 시작해서 VC의 코드가 많아지고 가독성이 떨어져 MVVM 아키텍처를 적용하였습니다. 초기에 아키텍처를 고민했다면 개발시간을 줄일 수 있었을 것 같아서 아쉬움이 남았습니다. <\br>
- 또한 모든 부분에 MVVM 아키텍처를 적용하지 못한것에 대해 아쉬움이 남았습니다. -> 하지만 실제로 아키텍처의 전환을 고려할 상황을 경험하는 것만으로도 좋은 경험이었다고 생각하며, 다음 프로젝트에서는 온전한 MVVM 아키텍처로 진행할 예정입니다.
- 코드의 가독성과 유지보수성을 고려하여 코드를 개선하고, 디버깅에 용이한 코드를 만드는 데 노력했습니다. Debugger, Breakpoint, lldb의 간단한 operater를 사용하여 문제가 생긴 부분을 좀 더 빠르게 찾을 수 있도록 디버깅스킬도 함께 베울 수 있는 기회였습니다.
