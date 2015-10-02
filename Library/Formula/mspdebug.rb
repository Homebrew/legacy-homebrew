class Mspdebug < Formula
  desc "Debugger for use with MSP430 MCUs"
  homepage "http://dlbeer.co.nz/mspdebug/"
  url "https://github.com/dlbeer/mspdebug/archive/v0.23.tar.gz"
  sha256 "e4db9ac519d5989aa48e43e92f04a6821a5dc7dff8c8b3795508a77ec4edde84"

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
