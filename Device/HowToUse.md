# How to use MiseCho Arduino

## 1. WiFi 정보 입력
1. ssid = 네트워크명
2. pass = 해당 네트워크 비밀번호
```arduino
// WiFi
const char ssid[] = "********";     // Wifi name
const char pass[] = "********";   // Wifi password
int status = WL_IDLE_STATUS;
```