import time
from datetime import datetime
from colorama import Fore, Back, Style
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager

def social_media_search(query, wait_time):
    # Sosyal medya platformları için URL'ler
    facebook_url = f"https://www.facebook.com/search/top?q={query}"
    twitter_url = f"https://twitter.com/search?q={query}"
    instagram_url = f"https://www.instagram.com/{query}"
    x_url = f"https://x.com/{query}"  # X platformu (eski Twitter)

    # WebDriver başlatma
    driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()))

    # Facebook kontrolü
    print(f"Facebook araması: {facebook_url}")
    check_social_media(driver, facebook_url, "Facebook", wait_time)

    # Twitter kontrolü
    print(f"Twitter araması: {twitter_url}")
    check_social_media(driver, twitter_url, "Twitter", wait_time)

    # Instagram kontrolü
    print(f"Instagram araması: {instagram_url}")
    check_social_media(driver, instagram_url, "Instagram", wait_time)

    # X (Twitter'ın yeni hali) kontrolü
    print(f"X araması: {x_url}")
    check_social_media(driver, x_url, "X", wait_time)

    driver.quit()  # WebDriver'ı kapatıyoruz


def check_social_media(driver, url, platform, wait_time):
    # Sosyal medya platformuna gidip sayfa içeriğini kontrol ediyoruz
    driver.get(url)
    time.sleep(wait_time)  # Kullanıcının belirlediği süre kadar bekliyoruz

    # Facebook kontrolü (user-not-found hatası için)
    if platform == "Facebook" and "user-not-found" in driver.page_source:
        print(f"{platform}: Kullanıcı adı bulunamadı.")

    # Twitter kontrolü (404 hatası kontrolü)
    elif platform == "Twitter" and "404" in driver.page_source:
        print(f"{platform}: Kullanıcı adı bulunamadı.")

    # Instagram kontrolü (Sayfa kaybolmuşsa)
    elif platform == "Instagram" and "This page isn’t available" in driver.page_source:
        print(f"{platform}: Kullanıcı adı bulunamadı.")

    # X (Yeni Twitter) kontrolü
    elif platform == "X" and "This account doesn’t exist" in driver.page_source:
        print(f"{platform}: Bu hesap mevcut değil.")

    # Eğer kullanıcı adı bulunduysa
    else:
        print(f"{platform}: Kullanıcı adı bulundu.")


def main():
    # Kullanıcıdan kullanıcı adı alıyoruz
    username = input("Kullanıcı adı girin (veya sosyal medya için kullanıcı adı): ").strip()

    # Eğer kullanıcı adı boşsa, mesaj gösterip çıkıyoruz
    if not username:
        print("Boş girdi=Menüye dönülüyor.")
        return  # main fonksiyonundan çıkıyoruz, Ruby tarafına geri dönecek

    # Kullanıcıdan bekleme süresi girilmesini istiyoruz
    try:
        wait_time = int(input("Sayfa yükleme süresi (saniye cinsinden): "))
        if wait_time < 1:
            print("Bekleme süresi 1 saniyeden küçük olamaz. Varsayılan 3 saniye olarak ayarlanacak.")
            wait_time = 3  # Varsayılan değer
    except ValueError:
        print("Geçersiz giriş. Varsayılan 3 saniye olarak ayarlanacak.")
        wait_time = 3  # Varsayılan değer

    # Sosyal medya aramaları yapıyoruz
    social_media_search(username, wait_time)


# Main fonksiyonunu çağırıyoruz
if __name__ == "__main__":
    main()
