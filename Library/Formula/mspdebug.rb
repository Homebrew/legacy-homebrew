class Mspdebug < Formula
  desc "Debugger for use with MSP430 MCUs"
  homepage "http://mspdebug.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mspdebug/mspdebug-0.22.tar.gz"
  sha256 "9a0550f3c7911bcc4e3231fff652c8f14763eb6a945609ce715db7164bf76c55"

  depends_on "libusb-compat"

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
