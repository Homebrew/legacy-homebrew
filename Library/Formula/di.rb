class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "http://www.gentoo.com/di/"
  url "http://gentoo.com/di/di-4.35.tar.gz"
  sha256 "2cdfface7a85e3a359cb228277b090a0648cabe18520e43b09919bdaf67b71d2"

  def install
    system "make", "prefix=#{prefix}", "DI_MANDIR=#{man1}"
    system "make", "install", "prefix=#{prefix}", "DI_MANDIR=#{man1}"
  end

  test do
    system "#{bin}/di"
  end
end
