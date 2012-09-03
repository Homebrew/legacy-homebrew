require 'formula'

class Mspdebug < Formula
  homepage 'http://mspdebug.sourceforge.net/'
  url 'http://sourceforge.net/projects/mspdebug/files/mspdebug-0.20.tar.gz'
  sha1 'ddf589e6e15c2577fc132001f757113309e134e9'

  depends_on 'libusb-compat'

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  def caveats; <<-EOS.undent
      You may need to install a kernel extension if you're having trouble with
      RF2500-like devices such as the TI Launchpad:
        http://mspdebug.sourceforge.net/faq.html#rf2500_osx
    EOS
  end

  def test
    system "#{bin}/mspdebug", "--help"
  end
end
