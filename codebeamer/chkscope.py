import pandas as pd

# 엑셀 파일 경로
file_path = 'TraceabilityReport-PorscheE4k1Cluster_0917.xlsx'

# 엑셀 파일 읽기
df = pd.read_excel(file_path)

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

# 1) initial 단계 분석
initial_result = count_unique_ids_by_status(df, 'ID', 'Status', 'Initial')

# 2) Level1 단계 분석
level1_result = count_unique_ids_by_status(df, 'Level 1 ID', 'Status', 'Level1')

# 결과 출력
print("📊 Initial 단계 결과:")
print(initial_result)

print("\n📊 Level1 단계 결과:")
print(level1_result)



