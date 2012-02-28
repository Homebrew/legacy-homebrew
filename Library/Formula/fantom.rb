require 'formula'

class Fantom < Formula
  homepage 'http://fantom.org'
  url 'http://fan.googlecode.com/files/fantom-1.0.61.zip'
  md5 '4ead834efae383be885401a747edc6af'

  def options
    [['--with-src', 'Also install fantom source'],
     ['--with-examples', 'Also install fantom examples']]
  end

  def install
    rm_f Dir["bin/*.exe", "lib/dotnet/*"]
    rm_rf "examples" unless ARGV.include? '--with-examples'
    rm_rf "src" unless ARGV.include? '--with-src'

    libexec.install Dir['*']

    bin.install_symlink Dir["#{libexec}/bin/*"]
  end
end
