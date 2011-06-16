require 'formula'

class Fantom < Formula
  url 'http://fan.googlecode.com/files/fantom-1.0.59.zip'
  homepage 'http://fantom.org'
  md5 '49f20d8a658e1e0b3daa861aa5287d11'

  def options
    [['--with-src', 'Also install fantom source'],
     ['--with-examples', 'Also install fantom examples']]
  end

  def install
    rm_f Dir["bin/*.exe", "lib/dotnet/*"]
    rm_rf Dir["examples"] unless ARGV.include? '--with-examples'
    rm_rf Dir["src"] unless ARGV.include? '--with-src'

    libexec.install Dir['*']

    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |f|
      next unless File.extname(f).empty?
      chmod 0755, f
      ln_s f, bin+File.basename(f)
    end
  end
end
