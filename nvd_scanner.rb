require 'net/http'
require 'json'
require 'uri'

class NVDScanner
  def initialize(cve_id)
    @cve_id = cve_id
    @base_url = "https://services.nvd.nist.gov/rest/json/cves/2.0?cveId=#{cve_id}"
  end

  def fetch_cve_data
    uri = URI.parse(@base_url)
    response = Net::HTTP.get_response(uri)

    case response.code.to_i
    when 200
      cve_data = JSON.parse(response.body)
      if cve_data["vulnerabilities"].empty?
        puts "CVE ID #{@cve_id} için veri bulunamadı."
        return nil
      else
        puts "CVE verisi başarıyla alındı!"

        cve_info = cve_data["vulnerabilities"].first["cve"]
        display_cve_info(cve_info)
        return cve_info
      end
    when 404
      puts "Hata: CVE ID #{@cve_id} bulunamadı (404)."
      return nil
    else
      puts "API Hatası: #{response.code} - #{response.message}"
      return nil
    end
  end

  def display_cve_info(cve_info)
    puts "CVE ID: #{cve_info['id']}"
    puts "Description: #{cve_info['descriptions']&.first['value'] || 'Açıklama bulunamadı.'}"

    # CVSS v3.1 verisini kontrol et
    if cve_info['metrics'] && cve_info['metrics']['cvssMetricV31']
      cvss_v3 = cve_info['metrics']['cvssMetricV31'].first['cvssData']
      puts "CVSS v3.1 Base Score: #{cvss_v3['baseScore']}"
    else
      puts "CVSS v3.1 verisi mevcut değil."
    end

    # Referansları kontrol et
    if cve_info['references'] && !cve_info['references'].empty?
      cve_info['references'].each do |ref|
        puts "Referans: #{ref['url']}"
      end
    else
      puts "Referans bulunamadı."
    end

    puts "Veri Alındı"
  end
end
