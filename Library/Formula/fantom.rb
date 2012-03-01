require 'formula'

class Fantom < Formula
  homepage 'http://fantom.org'
  url 'http://fan.googlecode.com/files/fantom-1.0.62.zip'
  md5 '253acd05563b58b41f8381435586e3d6'

  def options
    [['--with-src', 'Also install fantom source'],
     ['--with-examples', 'Also install fantom examples']]
  end

  def install
    rm_f Dir["bin/*.exe", "lib/dotnet/*"]
    rm_rf "examples" unless ARGV.include? '--with-examples'
    rm_rf "src" unless ARGV.include? '--with-src'

    libexec.install Dir['*']    
    system "chmod 0755 #{libexec}/bin/*"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end
end
