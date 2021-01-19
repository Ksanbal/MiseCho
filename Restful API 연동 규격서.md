# CheckPM - Rest API 연동 규격서<br>[http://127.0.0.1:8000/]
## 개요
- Project Name : CheckPM
- Project Manager : 김현균
- Version Number : V0.1
- Written Date : 2021.01.19

## 목차
1. [APP](#app)
   1. [회원가입(POST)](#1-회원가입)
   2. [로그인(POST)](#2-로그인)
   3. [메인페이지(GET)](#3-메인페이지)
   4. [디바이스 디테일 페이지(GET)](#4-디바이스-디테일-페이지)
   5. [디바이스 설정 변경사항 저장(PUT)](#5-디바이스-설정-변경사항-저장)
   6. [디바이스 전원 종료(PATCH)](#6-디바이스-전원-종료)
   7. [알림 리스트 페이지(GET)](#7-디바이스-전원-종료)
2. [Device](#device)
   1. [데이터 전송(POST)](#1-데이터-전송)

<br>

## APP
### 1. 회원가입
#### - Request - POST 방식으로 호출
- HTTP URL = 'http://127.0.0.1:8000/api/app/auth/signup/'
- Parameter 형식(POST 형식)

|파라미터명|타입|필수여부|설명|
|-|-|-|-|
|username|str|필수|가입자 아이디|
|password|str|필수|가입자 비밀번호|
|first_name|str|필수|가입자 이름|
|last_name|str|필수|가입자 성|
|email|str|필수|가입자 이메일|
|c_id|str|필수|가입자의 회사 고유 번호(개별 안내)|

- Parameter 형식(Header 형식)

|파라미터명|값|설명|
|-|-|-|
|Content-Type|application/json|JSON 통신|
<br>

#### - Response Format - JSON 형태로 반환
- 반환값 형식
  
|엘리먼트명|depth|배열구분|설명|값구분|
|-|-|-|-|-|
|token|1||해당 유저의 token값|200 : OK<br>400 : Bad Request

- 샘플 JSON 예제
```json
// 200 ok
{
  "token": "c95d8d14b465211491c140343d48951789d06abb"
}
// 400 bad request
{

}
```

---
### 2. 로그인
#### - Request - POST 방식으로 호출
- HTTP URL = 'http://127.0.0.1:8000/api/app/auth/signin/'
- Parameter 형식(POST 형식)

|파라미터명|타입|필수여부|설명|
|-|-|-|-|
|username|str|필수|회원 아이디|
|password|str|필수|회원 비밀번호|

- Parameter 형식(Header 형식)

|파라미터명|값|설명|
|-|-|-|
|Content-Type|application/json|JSON 통신|
<br>

#### - Response Format - JSON 형태로 반환
- 반환값 형식
  
|엘리먼트명|depth|배열구분|설명|값구분|
|-|-|-|-|-|
|token|1||해당 유저의 token값|200 : OK<br>400 : Bad Request

- 샘플 JSON 예제
```json
// 200 ok
{
  "token": "c95d8d14b465211491c140343d48951789d06abb"
}
// 400 bad request
{

}
```

---
### 3. 메인페이지
#### - Request - GET 방식으로 호출
- HTTP URL = 'http://127.0.0.1:8000/api/app/main/'
- Parameter 형식(GET 형식)

|파라미터명|타입|필수여부|설명|
|-|-|-|-|
|date|str|필수|선택된 날짜("2021-01-14")|

- Parameter 형식(Header 형식)

|파라미터명|값|설명|
|-|-|-|
|Content-Type|application/json|JSON 통신|
|Authorization|Token c95d8d14b465211491c140343d48951789d06abb|Token 값|
<br>

#### - Response Format - JSON 형태로 반환
- 반환값 형식
  
|엘리먼트명|depth|설명|값 구분|
|-|-|-|-|
|avgpm10|3|미세먼지 평균값|200 : OK<br>400 : Bad Request
|avgpm25|3|초미세먼지 평균값|
|id|3|디바이스 ID|
|name|3|디바이스명|
|connect|3|디바이스 연결상태|
|avgpm10|3|디바이스 미세먼지 평균값|
|avgpm25|3|디바이스 초미세먼지 평균값|

- 샘플 JSON 예제
```json
// 200 ok
[
  [
    {
      "avgpm10": 10,
      "avgpm25": 10
    },
    {
      "avgpm10": 20,
      "avgpm25": 20
    }
  ],
  [
    {
      "id": 1,
      "name": "측정기1",
      "connect": true,
      "avgpm10": 40,
      "avgpm25": 40
    },
    {
      "id": 2,
      "name": "측정기2",
      "connect": true,
      "avgpm10": 100,
      "avgpm25": 100
    }
  ]
]
// 400 bad request
{

}
```

---
### 4. 디바이스 디테일 페이지
#### - Request - GET 방식으로 호출
- HTTP URL = 'http://127.0.0.1:8000/api/app/device/(디바이스 ID)/'
- Parameter 형식(GET 형식)

|파라미터명|타입|필수여부|설명|
|-|-|-|-|
|date|str|필수|선택된 날짜("2021-01-14")|

- Parameter 형식(Header 형식)

|파라미터명|값|설명|
|-|-|-|
|Content-Type|application/json|JSON 통신|
|Authorization|Token c95d8d14b465211491c140343d48951789d06abb|Token 값|
<br>

#### - Response Format - JSON 형태로 반환
- 반환값 형식
  
|엘리먼트명|depth|설명|값 구분|
|-|-|-|-|
|avgpm10|3|미세먼지 평균값|200 : OK<br>400 : Bad Request
|avgpm25|3|초미세먼지 평균값|
|id|3|디바이스 아이디|
|name|3|디바이스명|
|connect|3|디바이스 연결상태|
|freq|3|디바이스 측정 주기|
|pmhigh|3|디바이스 알림 수준<br>('최고', '좋음', '양호', '보통', '나쁨', '상당히 나쁨', '매우 나쁨', '최악')|
|null_freq|3|디바이스 데이터 누락 횟수당 알림시간|
|work_s|3|디바이스 측정 시작시간|
|work_e|3|디바이스 측정 종료시간|
|comment|3|디바이스 설명|
|avgpm10|3|디바이스 미세먼지 평균값|
|avgpm25|3|디바이스 초미세먼지 평균값|
|c_id|3|디바이스 회사 번호|


- 샘플 JSON 예제
```json
// 200 ok
[
    [
        {
        "avgpm10": 10,
        "avgpm25": 10
        },
        {
        "avgpm10": 20,
        "avgpm25": 20
        }
    ],
    {
        "id": 1,
        "name": "측정기1",
        "connect": true,
        "freq": 6,
        "pmhigh": 6,
        "null_freq": 6,
        "work_s": "1000",
        "work_e": "2000",
        "comment": "PUT 테스트",
        "avgpm10": null,
        "avgpm25": null,
        "c_id": 1
    }
]
// 400 bad request
{

}
```

---
### 5. 디바이스 설정 변경사항 저장 
#### - Request - PUT 방식으로 호출
- HTTP URL = 'http://127.0.0.1:8000/api/app/device/(디바이스 ID)/'
- Parameter 형식(GET 형식)

|파라미터명|타입|필수여부|설명|
|-|-|-|-|
|name|str|필수|디바이스명|
|connect|bool|필수|디바이스 연결상태|
|freq|int|필수|디바이스 측정 주기|
|pmhigh|int|필수|디바이스 알림 수준<br>('최고', '좋음', '양호', '보통', '나쁨', '상당히 나쁨', '매우 나쁨', '최악')|
|null_freq|int|필수|디바이스 데이터 누락 횟수당 알림시간|
|work_s|str|필수|디바이스 측정 시작시간("0900")|
|work_e|str|필수|디바이스 측정 종료시간("1800")|
|comment|str|필수|디바이스 설명|
|c_id|int|필수|디바이스 회사 번호|


- Parameter 형식(Header 형식)

|파라미터명|값|설명|
|-|-|-|
|Content-Type|application/json|JSON 통신|
|Authorization|Token c95d8d14b465211491c140343d48951789d06abb|Token 값|
<br>

#### - Response Format - JSON 형태로 반환
- 반환값 형식
  
|엘리먼트명|depth|설명|값 구분|
|-|-|-|-|
|id|1|디바이스 아이디|
|name|1|디바이스명|
|connect|1|디바이스 연결상태|
|freq|1|디바이스 측정 주기|
|pmhigh|1|디바이스 알림 수준<br>('최고', '좋음', '양호', '보통', '나쁨', '상당히 나쁨', '매우 나쁨', '최악')|
|null_freq|1|디바이스 데이터 누락 횟수당 알림시간|
|work_s|1|디바이스 측정 시작시간|
|work_e|1|디바이스 측정 종료시간|
|comment|1|디바이스 설명|
|avgpm10|1|디바이스 미세먼지 평균값|
|avgpm25|1|디바이스 초미세먼지 평균값|
|c_id|1|디바이스 회사 번호|


- 샘플 JSON 예제
```json
// 200 ok
{
  "id": 1,
  "name": "측정기1",
  "connect": true,
  "freq": 6,
  "pmhigh": 6,
  "null_freq": 6,
  "work_s": "1000",
  "work_e": "2000",
  "comment": "PUT 테스트",
  "avgpm10": null,
  "avgpm25": null,
  "c_id": 1
}
// 400 bad request
{

}
```

---
### 6. 디바이스 전원 종료
#### - Request - PATCH 방식으로 호출
- HTTP URL = 'http://127.0.0.1:8000/api/app/device/(디바이스 ID)/'
- Parameter 형식(GET 형식)

|파라미터명|타입|필수여부|설명|
|-|-|-|-|
|-|-|-|-|


- Parameter 형식(Header 형식)

|파라미터명|값|설명|
|-|-|-|
|Authorization|Token c95d8d14b465211491c140343d48951789d06abb|Token 값|
<br>

#### - Response Format - JSON 형태로 반환
- 반환값 형식
  
|엘리먼트명|depth|설명|값 구분|
|-|-|-|-|
|status|1|성공여부|


- 샘플 JSON 예제
```json
// 200 ok
{
  "status": "success"
}
// 400 bad request
{

}
```

---
### 7. 디바이스 전원 종료
#### - Request - GET 방식으로 호출
- HTTP URL = 'http://127.0.0.1:8000/api/app/notice/'
- Parameter 형식(GET 형식)

|파라미터명|타입|필수여부|설명|
|-|-|-|-|
|-|-|-|-|


- Parameter 형식(Header 형식)

|파라미터명|값|설명|
|-|-|-|
|Authorization|Token c95d8d14b465211491c140343d48951789d06abb|Token 값|
<br>

#### - Response Format - JSON 형태로 반환
- 반환값 형식
  
|엘리먼트명|depth|설명|값 구분|
|-|-|-|-|
|id|2|알림 id|
|date|2|알림생성 날짜|
|content|2|알림 내용|
|d_id|2|다바이스 ID|
|c_id|2|회사 ID|


- 샘플 JSON 예제
```json
// 200 ok
[
  {
    "id": 1,
    "date": "2021-01-14T16:12:52.643081",
    "content": "미세먼지 상태가 상당히 나쁨입니다. 확인해주세요.",
    "d_id": 2,
    "c_id": 1
  },
  {
    "id": 2,
    "date": "2021-01-14T16:13:22.744588",
    "content": "미세먼지 상태가 상당히 나쁨입니다. 확인해주세요.",
    "d_id": 2,
    "c_id": 1
  }
]
// 400 bad request
{

}
```
---
## Device
### 1. 데이터 전송
#### - Request - POST 방식으로 호출
- HTTP URL = 'http://127.0.0.1:8000/api/device/datapost/'
- Parameter 형식(POST 형식)

|파라미터명|타입|필수여부|설명|
|-|-|-|-|
|pm10|int|필수|미세먼지 값|
|pm25|int|필수|초미세먼지 값|
|d_id|int|필수|디바이스 ID|


- Parameter 형식(Header 형식)

|파라미터명|값|설명|
|-|-|-|
|Content-Type|application/json|JSON 통신|
<br>

#### - Response Format - JSON 형태로 반환
- 반환값 형식
  
|엘리먼트명|depth|설명|값 구분|
|-|-|-|-|
|-|-|-|-|


- 샘플 JSON 예제
```json
// 200 ok
{

}
// 400 bad request
{

}
```