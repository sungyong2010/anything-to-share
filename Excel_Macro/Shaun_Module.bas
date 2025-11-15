Attribute VB_Name = "Shaun_Module"
Sub ResizeAllCharts()
    Dim chtObj As ChartObject
    Dim ws As Worksheet
    
    ' 원하는 크기 설정 (단위: 포인트)
    Dim newWidth As Double
    Dim newHeight As Double
    
    newWidth = 400   ' 차트 너비
    newHeight = 300  ' 차트 높이
    
    ' 현재 시트의 모든 차트 크기 변경
    Set ws = ActiveSheet
    For Each chtObj In ws.ChartObjects
        chtObj.Width = newWidth
        chtObj.Height = newHeight
    Next chtObj
    
    MsgBox "모든 차트 크기가 동일하게 변경되었습니다!", vbInformation
End Sub

Sub CopyRangeWithSize()
    Dim sourceRange As Range
    Dim targetRange As Range
    
    ' 원본 범위 선택
    Set sourceRange = Application.InputBox("원본 범위를 선택하세요", Type:=8)
    
    ' 대상 범위 선택
    Set targetRange = Application.InputBox("대상 범위를 선택하세요", Type:=8)
    
    ' 값과 서식 복사
    sourceRange.Copy
    targetRange.PasteSpecial Paste:=xlPasteAll
    
    ' 열 너비 복사
    Dim i As Long
    For i = 1 To sourceRange.Columns.Count
        targetRange.Columns(i).ColumnWidth = sourceRange.Columns(i).ColumnWidth
    Next i
    
    ' 행 높이 복사
    Dim j As Long
    For j = 1 To sourceRange.Rows.Count
        targetRange.Rows(j).RowHeight = sourceRange.Rows(j).RowHeight
    Next j
    
    Application.CutCopyMode = False
    MsgBox "복사가 완료되었습니다!", vbInformation
End Sub

Sub AddJiraHyperlinks()
    Dim cell As Range
    Dim baseUrl As String
    
    ' Jira 기본 URL
    baseUrl = "http://jira.lge.com/issue/browse/"
    
    ' 현재 선택된 범위의 각 셀에 대해 실행
    For Each cell In Selection
        If cell.Value <> "" Then
            ' 하이퍼링크 추가
            cell.Hyperlinks.Add Anchor:=cell, _
                Address:=baseUrl & cell.Value, _
                TextToDisplay:=cell.Value
        End If
    Next cell
    
    MsgBox "하이퍼링크가 추가되었습니다!", vbInformation
End Sub

Sub RandomSortRows()
    Dim ws As Worksheet
    Dim rng As Range
    Dim lastRow As Long
    Dim lastCol As Long
    Dim i As Long
    
    ' 현재 시트 지정
    Set ws = ActiveSheet
    
    ' 마지막 행과 열 찾기
    lastRow = ws.Cells(ws.Rows.Count, 1).End(xlUp).Row
    lastCol = ws.Cells(1, ws.Columns.Count).End(xlToLeft).Column
    
    ' 난수 넣을 임시 열 추가 (마지막 열 다음)
    For i = 1 To lastRow
        ws.Cells(i, lastCol + 1).Value = Rnd()
    Next i
    
    ' 난수 기준으로 전체 행 정렬
    Set rng = ws.Range(ws.Cells(1, 1), ws.Cells(lastRow, lastCol + 1))
    rng.Sort Key1:=ws.Cells(1, lastCol + 1), Order1:=xlAscending, Header:=xlNo
    
    ' 임시 열 삭제
    ws.Columns(lastCol + 1).Delete
End Sub

Sub Merge_Selected_Sheets_TableSafe()

    Dim ws As Worksheet
    Dim mergedWs As Worksheet
    Dim destRow As Long
    Dim headerCopied As Boolean
    Dim lastRow As Long, lastCol As Long
    Dim rng As Range
    Dim selectedSheets As Sheets
    
    ' 선택된 시트 목록을 먼저 저장
    Set selectedSheets = ActiveWindow.selectedSheets
    
    ' 기존 Merged 삭제
    On Error Resume Next
    Application.DisplayAlerts = False
    Worksheets("Merged").Delete
    Application.DisplayAlerts = True
    On Error GoTo 0
    
    ' 통합 시트 생성 (새로 만든 시트는 선택되지 않도록)
    Sheets(1).Select ' 또는 아무 단일 시트 선택
    Set mergedWs = Worksheets.Add(After:=Worksheets(Worksheets.Count))
    mergedWs.Name = "Merged"
    
    destRow = 1
    headerCopied = False
    
    ' 선택된 시트 순회
    For Each ws In selectedSheets
        If ws.Name <> mergedWs.Name Then
            
            ' ▼▼ 1) 시트에 표(ListObject)가 있는 경우 --------------------------------
            If ws.ListObjects.Count > 0 Then
                Set rng = ws.ListObjects(1).DataBodyRange
                lastRow = rng.Rows.Count + 1
                lastCol = rng.Columns.Count
                
                If Not headerCopied Then
                    mergedWs.Range("A1").Resize(lastRow, lastCol).Value = _
                        ws.Range(ws.Cells(1, 1), ws.Cells(lastRow, lastCol)).Value
                    destRow = lastRow + 1
                    headerCopied = True
                Else
                    mergedWs.Range("A" & destRow).Resize(lastRow - 1, lastCol).Value = rng.Value
                    destRow = destRow + (lastRow - 1)
                End If
            
            ' ▼▼ 2) 일반 시트 구조인 경우 ------------------------------------------
            Else
                lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row
                lastCol = ws.Cells(1, ws.Columns.Count).End(xlToLeft).Column
                
                If lastRow < 2 Then GoTo NextSheet
                
                If Not headerCopied Then
                    mergedWs.Range("A1").Resize(lastRow, lastCol).Value = _
                        ws.Range(ws.Cells(1, 1), ws.Cells(lastRow, lastCol)).Value
                    destRow = lastRow + 1
                    headerCopied = True
                Else
                    mergedWs.Range("A" & destRow).Resize(lastRow - 1, lastCol).Value = _
                        ws.Range(ws.Cells(2, 1), ws.Cells(lastRow, lastCol)).Value
                    destRow = destRow + (lastRow - 1)
                End If
            End If
        End If
NextSheet:
    Next ws
    
    MsgBox "통합 완료!", vbInformation
End Sub








