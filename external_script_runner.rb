class ExternalScriptRunner
  def self.run_script
    python_path = "C:/Users/emirs/AppData/Local/Programs/Python/Python313/python.exe" # Doğru Python yolu
    script = "C:/Users/emirs/RubymineProjects/untitled/VaOsint/osm.py"

    puts "DEBUG: Python yolu -> #{python_path}"
    puts "DEBUG: Script yolu -> #{script}"
    puts "DEBUG: Çalıştırılacak komut -> \"#{python_path}\" \"#{script}\""

    if File.exist?(script)
      puts "Çalıştırılıyor: #{script}"
      system("\"#{python_path}\" \"#{script}\"")
    else
      puts "Hata: Script bulunamadı - #{script}"
    end
  end
end
