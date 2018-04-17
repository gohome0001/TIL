# Lapio 숙제 ^^

## Web5_Project3

아주 간단한 LFI 문제

파일을 include 할 때, php file은 실행되어 나오기 때문에 소스코드 못봄!

php://filter를 통해 base64로 encode된 source code를 얻을 수 있다!

`flag : LFI_WITH_BASE64_IS_VERY_DANGEROUS_!`