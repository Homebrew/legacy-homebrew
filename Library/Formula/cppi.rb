require 'formula'

class Cppi < Formula
  homepage 'http://www.gnu.org/software/cppi/'
  url 'http://ftpmirror.gnu.org/cppi/cppi-1.18.tar.xz'
  mirror 'http://ftp.gnu.org/cppi/cppi-1.18.tar.xz'
  sha1 '5f46d04041fc6e3413d5312db5b99329143a7c33'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/cppi", "--version"
  end
end
