require 'formula'

class Ant < Formula
  homepage 'http://ant.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=ant/binaries/apache-ant-1.9.3-bin.tar.gz'
  sha1 '11a0b936fba02f96b8d737d90c610382232ffea6'

  keg_only :provided_by_osx if MacOS.version < :mavericks

  def install
    rm Dir['bin/*.{bat,cmd,dll,exe}']
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/ant", "-version"
  end
end
