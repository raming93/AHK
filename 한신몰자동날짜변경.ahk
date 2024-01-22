#NoEnv                  	; ȯ�溯��X, ȿ��up
#Persistent  				; ��ũ��Ʈ�� ������� �ʵ��� �����մϴ�.
SendMode Input          	; �ӵ�, ������ ��õ
SetWinDelay, 300           	; â���(����, Ȱ��ȭ ��) �� ����(�ŷڼ�UP /�⺻100)
#Singleinstance Force     	; ������ ���¿��� ���� ���� Reload ����
CoordMode, Mouse, Screen 	; ��üȭ�� ���콺
^r::Reload                  ; �������� �ʰ� �ٽ� �����ϱ�(��Ű Ctrl+r)





prevDate(varDate)
{
    ; ���ú��� x�� ����/���� ��¥ ���� PreviousDate ������ �Ҵ�
    FormatTime, CurrentDateTime,, yyyyMMdd
    Today := CurrentDateTime
    EnvAdd, Today, %varDate%, Days ; x�� ������ ��¥ ���
    FormatTime, PreviousDate, %Today%, yyyyMMdd
    return PreviousDate
}






CheckAndRunScript:
    FormatTime, CurrentTime,, HHmm ; ���� �ð��� HHmm �������� ������
    if (CurrentTime >= 1234 and CurrentTime <= 1235) ; ���� 12:34:00 �� ��ũ��Ʈ�� ����
    {
        SetTimer, updateDate, Off ; �̹� ���� ���� Ÿ�̸Ӹ� ��
        updateDate ; ��ũ��Ʈ�� ����
        SetTimer, updateDate, 86400000 ; 24�ð�(1��) �ֱ�� Ÿ�̸� �缳��
    }
    else
    {
        ; ���� �ð� ���
        FormatTime, TargetTime, 123400, HHmm ; ���� ���� �ð� ���� (���⼭�� 12:34:00���� ����)
        FormatTime, CurrentDateTime,, yyyyMMddHHmm
        TargetDateTime := CurrentDateTime
        StringMid, TargetDateTime, TargetDateTime, 1, 8
        TargetDateTime := TargetDateTime TargetTime
        EnvSub, TimeDiff, TargetDateTime, CurrentDateTime

        ; ���� �ð����� ���
        Sleep, %TimeDiff%
        GoSub, CheckAndRunScript ; �ٽ� üũ�ϰ� ��ũ��Ʈ ����
    }
    return





updateDate:
    prev3days := prevDate(-3)
    Next4Days := prevDate(4)

    Send, {F3}
    Sleep, 3000
    ControlSend, fp32DateTime2xOcx1, %prev3days%, �ѽž�ǰ - srds30db_Hanshin ; �������� ����
    Sleep, 1000
    ControlSend, fp32DateTime2xOcx4, %Next4Days%, �ѽž�ǰ - srds30db_Hanshin ; �������� ����
    Sleep, 3000
    Send, {F2}
    return

#Persistent ; ��ũ��Ʈ�� ������� �ʵ��� �����մϴ�.
SetTimer, CheckAndRunScript, 1000 ; 1�ʸ��� CheckAndRunScript �Լ��� ȣ���մϴ�.
return
