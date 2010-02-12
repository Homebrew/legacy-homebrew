require 'formula'

class Multitail <Formula
  url 'http://www.vanheusden.com/multitail/multitail-5.2.2.tgz'
  homepage 'http://www.vanheusden.com/multitail/download.html'
  md5 'ab2c198381e9ff6271ce56bdcb06f963'

  def install
    system "env", "DESTDIR=#{prefix}", "make", "-f", "makefile.macosx", "multitail"

    bin.install "multitail"
    man1.install gzip("multitail.1")
  end
end
