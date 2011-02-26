require 'formula'

class Fantom <Formula
  url 'http://fan.googlecode.com/files/fantom-1.0.57.zip'
  homepage 'http://fantom.org'
  md5 '5f5b7fbaae4e2cf76ded359c57530af2'

  def install
    rm_f Dir["bin/*.exe", "lib/dotnet/*"]
    rm_rf Dir["examples", "src"]
    libexec.install Dir['*']
    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |f|
      next unless File.extname(f).empty?
      ln_s f, bin+File.basename(f)
    end
  end
end
