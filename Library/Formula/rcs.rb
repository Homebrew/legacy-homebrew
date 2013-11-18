require 'formula'

class Rcs < Formula
  homepage 'https://www.gnu.org/software/rcs/'
  url 'http://ftpmirror.gnu.org/rcs/rcs-5.9.1.tar.xz'
  mirror 'http://ftp.gnu.org/gnu/rcs/rcs-5.9.1.tar.xz'
  sha1 '2e1017c24cd79ed434fa80e384ba844738c2cbfe'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"merge", "--version"
  end
end
