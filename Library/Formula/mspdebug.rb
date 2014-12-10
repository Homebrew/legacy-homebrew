require 'formula'

class Mspdebug < Formula
  homepage 'http://mspdebug.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/mspdebug/mspdebug-0.22.tar.gz'
  sha1 'f55692d90ccb1f3686e94df53e5e30408fde963f'

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

  test do
    system "#{bin}/mspdebug", "--help"
  end
end
