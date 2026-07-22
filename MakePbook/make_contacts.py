import random
import base64
import os

# 아주 작은 더미 사진 (1x1 픽셀) - 실제로는 원하는 사진으로 바꿔서 사용 가능
with open("sample_photo.jpg", "wb") as f:  # ← 여기에 너가 원하는 사진 파일 넣어도 됨
    f.write(b"\xff\xd8\xff\xe0\x00\x10JFIF...")  # dummy

with open("sample_photo.jpg", "rb") as f:
    photo_base64 = base64.b64encode(f.read()).decode('utf-8')

def generate_random_name():
    first = ['김','이','박','최','정','강','조','윤','장','임','한','오','서','신']
    last = ['민준','서연','도윤','지우','하준','서아','지호','은우','수아','예준']
    return random.choice(first) + random.choice(last)

def create_phonebook(total=20000):
    filename = f"contacts_with_photos_{total}.vcf"
    count = 0
    
    with open(filename, "w", encoding="utf-8") as f:
        for i in range(total):
            name = generate_random_name()
            phone = f"010-{random.randint(1000,9999)}-{random.randint(1000,9999)}"
            
            f.write("BEGIN:VCARD\n")
            f.write("VERSION:3.0\n")
            f.write(f"FN:{name}\n")
            f.write(f"TEL;TYPE=CELL:{phone}\n")
            f.write(f"EMAIL:{name.lower()}{i}@example.com\n")
            f.write(f"PHOTO;ENCODING=BASE64;TYPE=JPEG:{photo_base64}\n")
            f.write("END:VCARD\n")
            
            count += 1
            if count % 2000 == 0:
                print(f"진행률: {count}/{total}개 완료")
    
    size_mb = os.path.getsize(filename) / (1024 * 1024)
    print(f"\n완료! 파일명: {filename}")
    print(f"파일 크기: {size_mb:.1f} MB")

# 실행
create_phonebook(20000)