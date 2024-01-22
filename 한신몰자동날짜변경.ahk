#NoEnv                  	; 환경변수X, 효율up
#Persistent  				; 스크립트가 종료되지 않도록 유지합니다.
SendMode Input          	; 속도, 안전성 추천
SetWinDelay, 300           	; 창명령(생성, 활성화 등) 후 지연(신뢰성UP /기본100)
#Singleinstance Force     	; 미종료 상태에서 새로 켜짐 Reload 연계
CoordMode, Mouse, Screen 	; 전체화면 마우스
^r::Reload                  ; 종료하지 않고 다시 시작하기(핫키 Ctrl+r)





prevDate(varDate)
{
    ; 오늘부터 x일 이전/후의 날짜 값을 PreviousDate 변수에 할당
    FormatTime, CurrentDateTime,, yyyyMMdd
    Today := CurrentDateTime
    EnvAdd, Today, %varDate%, Days ; x일 이전의 날짜 계산
    FormatTime, PreviousDate, %Today%, yyyyMMdd
    return PreviousDate
}






CheckAndRunScript:
    FormatTime, CurrentTime,, HHmm ; 현재 시간을 HHmm 형식으로 가져옴
    if (CurrentTime >= 1234 and CurrentTime <= 1235) ; 매일 12:34:00 에 스크립트를 실행
    {
        SetTimer, updateDate, Off ; 이미 실행 중인 타이머를 끔
        updateDate ; 스크립트를 실행
        SetTimer, updateDate, 86400000 ; 24시간(1일) 주기로 타이머 재설정
    }
    else
    {
        ; 남은 시간 계산
        FormatTime, TargetTime, 123400, HHmm ; 다음 실행 시간 설정 (여기서는 12:34:00으로 설정)
        FormatTime, CurrentDateTime,, yyyyMMddHHmm
        TargetDateTime := CurrentDateTime
        StringMid, TargetDateTime, TargetDateTime, 1, 8
        TargetDateTime := TargetDateTime TargetTime
        EnvSub, TimeDiff, TargetDateTime, CurrentDateTime

        ; 남은 시간까지 대기
        Sleep, %TimeDiff%
        GoSub, CheckAndRunScript ; 다시 체크하고 스크립트 실행
    }
    return





updateDate:
    prev3days := prevDate(-3)
    Next4Days := prevDate(4)

    Send, {F3}
    Sleep, 3000
    ControlSend, fp32DateTime2xOcx1, %prev3days%, 한신약품 - srds30db_Hanshin ; 시작일자 변경
    Sleep, 1000
    ControlSend, fp32DateTime2xOcx4, %Next4Days%, 한신약품 - srds30db_Hanshin ; 종료일자 변경
    Sleep, 3000
    Send, {F2}
    return

#Persistent ; 스크립트가 종료되지 않도록 유지합니다.
SetTimer, CheckAndRunScript, 1000 ; 1초마다 CheckAndRunScript 함수를 호출합니다.
return
