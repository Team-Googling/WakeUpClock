# ⏰ Wake Up Clock

```

세계시간, 알람, 타이머, 스탑워치 기능이 있는 알람앱!📢

```

---


## Table of Contents
1. [Description](#-description)
2. [Stacks](#-stacks)
3. [WireFrames](#-wireFrames)
4. [Main Feature](#-main-feature)
5. [Project Structure](#%EF%B8%8F-project-structure)
6. [Developer](#-developer)

</br>

## 🌟 Description

`TEAM` : 구글링잘하조

`Period` : 24.05.13 ~ 24.05.24

세계 시간, 알람, 타이머, 스탑워치 기능이 있고 백그라운드 알림이 재생되는 iOS 어플리케이션

</br>

💡**기능**

- 원하는 알람 설정 및 삭제

- 스톱워치, 랩타임, 세계 시간 등 다양한 기능 제공
- 설정된 시간이 되면 어플을 종료해도 Push알림과 함께 사운드가 재생
- 버튼을 통한 다크모드와 라이트모드 구분


</br>

## 🛠️ Stacks
**Environment**

<img src="https://img.shields.io/badge/-Xcode-147EFB?style=flat&logo=xcode&logoColor=white"/> <img src="https://img.shields.io/badge/-git-F05032?style=flat&logo=git&logoColor=white"/> <img src="https://img.shields.io/badge/-github-181717?style=flat&logo=github&logoColor=white"/>

**Language**

<img src="https://img.shields.io/badge/-swift-F05138?style=flat&logo=swift&logoColor=white"/> 

**Communication**

<img src="https://img.shields.io/badge/-slack-4A154B?style=flat&logo=slack&logoColor=white"/> <img src="https://img.shields.io/badge/-notion-000000?style=flat&logo=notion&logoColor=white"/>  <img src="https://img.shields.io/badge/-figma-609926?style=flat&logo=figma&logoColor=white"/>


</br>


## 🎨 WireFrames
<img width="800" alt="image" src="https://github.com/Team-Googling/WakeUpClock/assets/129912074/b6f99a76-d7aa-4a3c-abf5-af0f6ce207c0">

</br></br>

---

## 📱 Main Feature
### 1) Clock Page
<img width="200" alt="image" src="https://github.com/Team-Googling/WakeUpClock/assets/129912074/af02845a-4116-4a09-a359-98beb206561c">
<img width="200" alt="image" src="https://github.com/Team-Googling/WakeUpClock/assets/129912074/0ba803a0-e947-43d4-beaa-5a846b4811a1">
<br><br>

- **TimeZone**을 활용한 시간 포맷
- 세계시간 & 내 위치의 현재 시간과의 시차 확인 가능!

</br>

### 2) AlarmList Page

- 설정한 알람 목록 확인
- 스위치를 통한 알람 설정
- 설정한 시간에 Push 알림과 사운드 재생
- CoreData 삭제

</br>

### 3) New Alarm Page

- UIPickerView로 시간 설정
- 원하는 요일에 체크박스와 이름 설정 가능
- 코어 데이터에 알람 정보 저장

</br>

### 4) Timer Page

- Duration Picker를 사용한 시간 설정
- 타이머 실행 시 코어데이터에 저장
- 최근 타이머 목록에서 확인 & 실행 가능

</br>

### 5) Stopwatch Page

- 실행하면 분, 초, 밀리세컨드 단위로 시간 흐름
- 랩타임 기능 -> 이전 기록과의 시간 차이 & 측정 시간 기록
- 버튼 상태 변화

<br>

## 🏛️ Project Structure

```markdown
WakeUpClock 
├── Helpers
│   ├── UIImage+
│   ├── TimeZone+
|   ├── UIFactory
├── Models
│   ├── AlarmModel
│   ├── Stopwatch
├── CoreData
│   ├── MyAlarm+CoreDataClass
│   ├── MyAlarm+CoreDataProperties
│   ├── StopwatchTimer+CoreDataClass
│   ├── StopwatchTimer+CoreDataProperties
│   ├── StopwatchLap+CoreDataClass
│   ├── StopwatchLap+CoreDataProperties
│   └── StopwatchCoreDataManager
├── Controllers
│   ├── TabBarController
│   ├── ClockViewController
│   ├── AlarmViewController
│   ├── NewAlarmViewController
│   ├── TimerViewController
│   └── StopwatchViewController
├── Cells
│   ├── TimerTableViewCell
│   ├── StopwatchCell
│   ├── ClockCell
│   └── AlarmCell
└ 
```
<br>

## 👨‍👩‍👧‍👦 Developer
<table>
  <tbody>
    <tr>
      <td align="center"><a href="https://github.com/wxxd-fxrest"><img src="https://github.com/Team-Googling/WakeUpClock/assets/129912074/c85dfb5d-a4c3-4be6-84d0-d508eabc2746" width="108px;"><br /><sub><b>윤소연</b></sub></a><br /></a></td>
      <td align="center"><a href="https://github.com/Imhnjng"><img src="https://github.com/Team-Googling/WakeUpClock/assets/129912074/edfe6dbd-cd14-4c94-ab7a-6785ff309ceb" width="100px;"><br /><sub><b>임현정</b></sub></a><br /></a></td>
      <td align="center"><a href="https://github.com/limlogging"><img src="https://github.com/Team-Googling/WakeUpClock/assets/129912074/a5087034-7b39-406f-8ee7-0c2d4bffa55b" width="100px;"><br /><sub><b>임형섭</b></sub></a><br /></a></td>
      <td align="center"><a href="https://github.com/yyujnn"><img src="https://github.com/Team-Googling/WakeUpClock/assets/129912074/e86c3581-6fea-4523-b775-032125f88992" width="100px;"><br /><sub><b>정유진</b></sub></a><br /></a></td>
     <tr/>
  </tbody>
</table>


*  **윤소연** 
    - 알람 리스트 페이지 UI 및 기능
    - 네비게이션,탭 바 UI 수정
    - Dark/Light 모드 변경
    - Push Alarm 구현
 
*  **임현정** 
    - merge 담당
    - 타이머 페이지 UI 및 기능
    - Push Alarm 구현
 
*  **임형섭** 
    - 알람 추가 페이지 UI 및 기능

*  **정유진**
    - 초기 작업 설계
    - 스톱워치 페이지 UI 및 기능
    - 랩 타임 구현
    - 세계 시계 UI 및 기능
    - Git 문제 해결

<br>
