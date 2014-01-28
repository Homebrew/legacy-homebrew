require 'formula'

class Rcs < Formula
  homepage 'https://www.gnu.org/software/rcs/'
  url 'http://ftpmirror.gnu.org/rcs/rcs-5.9.2.tar.xz'
  mirror 'http://ftp.gnu.org/gnu/rcs/rcs-5.9.2.tar.xz'
  sha1 'cb053f6ba87ab6ea03306d6241e1cde67182100b'

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
