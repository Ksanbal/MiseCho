# API request & response List

## Device (AWS Iot Core)
---
1. 데이터 전송
    - Method : POST
    - Request : device_id, pm2.5, pm10
    - Response : 200 or 400

1. 설정 변경사항 전송
    - api -> device

1. 전원끄기
    - api -> device


## APP
---
1. 회원관리
    - Method : Post
    - Request : username, pw
    - Response : 200 or 400

1. main page
    - Method : GET
    - Request : 
    - Response : 전체 평균 data, 측정기list (id, 이름, 전원, 연결상태, avg(pm10), avg(pm2.5))

1. 알림 list
    - Method : GET
    - Request : x
    - Response : 시간, 기기명, 내용

1. 앱 push 알림

1. 디바이스 상황
    - Method : GET
    - Request : x
    - Response : 시간대별 데이터, 일별 평균 데이터, 기존 설정 정보

1. 디바이스 설정 변경
    - Method : POST
    - Request : 전원, 미세먼지 측정주기, 위험 미세먼지 정도, 알림 데이터 누락 횟수, 기기 작동시간(start, end)
    - Response : 200 or 400