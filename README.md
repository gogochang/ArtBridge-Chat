# ArtBridge

음악 관련 사람들을 위한 앱,

주요기능
  - 커뮤니티 기능 ( 채팅, 게시판 )
  - 과외 모집, 신청 등
사용기술
  - Swift, SwiftUI, Firebase, Combine

진행사항
  - 게시판 관련 기능
    - 게시판 작성/수정/삭제 기능 추가
    - 로그인된 계정의 username으로 작성자 이름을 사용하도록 수정, nil이면 "익명"이라는 작성자이름으로 사용
    - TODO: 로그인된 계정과 작성된 글의 작성자가 일치할 때만 수정/삭제 가능하도록 수정 필요
    
  - 계정 관련 기능
    - 로그인/회원가입/로그아웃 기능 추가
    - 로그인 성공 시 MyPage의 프로필에 계정 정보 표시
    - 로그인이 되면 계정설정,로그아웃 버튼 활성화, 로그아웃하면 다시 비활성화
    - 로그아웃 버튼 클릭 시 Alert로 재확인
    - TODO: 로그인/회원가입/로그아웃 성공 시 유저가 인식 가능 하도록 애니매이션 발생 필요
    - TODO: 과외 구인/구직자 구별 기능 추가 필요
    
  - 채팅
    - 채팅방 생성
      - 유저목록에서 특정 유저에게 채팅하기위한 채팅방 생성
    - 채팅방 목록
      - 현재 로그인된 유저의 채팅방 목록응ㄹ 가져옴
    - 메세지 실시간 송수신 기능 추가
    
    - TODO: 채팅방, 메세지기능

