require_relative 'nvd_scanner'  # NVDScanner sınıfını çağırma
require_relative 'external_script_runner' #external dış script çağırma için

require 'colorize'



class CVEApp
  def initialize
    @scanner = nil  # Başlangıçta @scanner nil olacak
  end

  def menu
    puts "1. NVD CVE Tarama"
    puts "2. Global Osint Menü"
    puts "3. İletişim"
    puts "4. Çıkış"
  end

  def secim
    print "Seçiminizi yapın (1-7): "
    gets.chomp.to_i
  end

  def cve_tarama
    puts "NVD CVE Tarama Başlatılıyor..."
    print "CVE ID girin (Örnek: CVE-2021-12345) veya çıkmak için 'exit' yazın: "
    cve_id = gets.chomp
    return false if cve_id.downcase == 'exit'

    @scanner = NVDScanner.new(cve_id)  # CVE ID'yi geçiyoruz
    @scanner.fetch_cve_data  # Veriyi alıyoruz
  end

  def run
    loop do
      menu  # Ana menü her seferinde gösterilecek
      choice = secim  # Kullanıcının seçimi alınacak

      case choice
      when 1
        puts "NVD CVE Tarama başlatılıyor..."
        cve_tarama  # CVE ID sorulacak ve tarama yapılacak sınıfı çağrıyor
      when 2
        puts "Global Osint Menü başlatılıyor..."
        puts "Örnek kullancı adı: SentiTones".colorize(:red)
        ExternalScriptRunner.run_script
      when 3
        puts "İletişim"
      when 4
        puts "Çıkış yapılıyor..."
        break
      else
        puts "Geçersiz seçim, lütfen 1-7 arasında bir seçenek girin."
      end
    end
  end
end

CVEApp.new.run

=begin

Buarada insgramdan takip ederseniz sevinirim: sentitones

=end