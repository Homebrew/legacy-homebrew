class Nfdump < Formula
  homepage "http://nfdump.sourceforge.net"
  url "https://downloads.sourceforge.net/project/nfdump/stable/nfdump-1.6.13/nfdump-1.6.13.tar.gz"
  sha256 "251533c316c9fe595312f477cdb051e9c667517f49fb7ac5b432495730e45693"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/nfdump", "-Z 'host 8.8.8.8'"
  end
end
