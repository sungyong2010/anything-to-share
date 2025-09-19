import pandas as pd
import inspect
import tkinter as tk
from tkinter import filedialog

def pause(message=None):
    RED = "\033[91m"
    RESET = "\033[0m"
    # 호출 정보를 가져옵니다
    current_stack = inspect.stack()
    # stack[1]이 pause()를 호출한 위치
    caller_frame = current_stack[1]
    filename = caller_frame.filename
    lineno = caller_frame.lineno
    code_context = caller_frame.code_context[0].strip() if caller_frame.code_context else "No code context"
    print(f"{RED}Called file: {filename}, line: {lineno}{RESET}")
    # print(f"호출 코드: {code_context}")

    if message:
        print(f"{RED}==> [PAUSE] {message}{RESET}")

    input("Press Enter to continue...\n")

# 파일 탐색기 열기
root = tk.Tk()
root.withdraw()  # Tk 창 숨기기
file_path = filedialog.askopenfilename(
    title='엑셀 파일을 선택하세요',
    filetypes=[('Excel files', '*.xlsx;*.xls')]
)

# 6번째 행부터 컬럼명이 시작됨 → header=5
df = pd.read_excel(file_path, header=5)


# 결과 저장용 함수
def count_unique_ids_by_status(df, id_column, status_column, label):
    result = (
        df[[id_column, status_column]]
        .drop_duplicates()
        .groupby(status_column)[id_column]
        .nunique()
        .reset_index()
        .rename(columns={id_column: f'{label}_Unique_ID_Count'})
    )
    return result

# 1) Initial 단계 분석
initial_result = count_unique_ids_by_status(df, 'ID', 'Status', 'Initial')

# 2) Level 1 단계 분석
level1_result = count_unique_ids_by_status(df, 'ID.1', 'Status.1', 'Level1')  # Status.1은 Level 1 쪽 Status 컬럼명일 수 있음

# 결과 출력
print("----------------------------------------------")
print("📊 Initial:")
print(initial_result)

print("\n📊 Level1:")
print(level1_result)
print("----------------------------------------------")
pause("분석이 완료되었습니다.")