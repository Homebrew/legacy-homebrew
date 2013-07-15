require 'formula'

class Mspdebug < Formula
  homepage 'http://mspdebug.sourceforge.net/'
  url 'http://sourceforge.net/projects/mspdebug/files/mspdebug-0.21.tar.gz'
  sha1 'a439acd166e90bfd19ddf2c3459eee9643e55368'

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
