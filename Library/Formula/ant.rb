require 'formula'

class Ant < Formula
  homepage 'http://ant.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=ant/binaries/apache-ant-1.9.2-bin.tar.gz'
  sha1 'fa2c18a27cdf407f5d8306bbc0f0b29513d915d8'

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
