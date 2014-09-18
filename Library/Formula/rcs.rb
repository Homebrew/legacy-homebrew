require "formula"

class Rcs < Formula
  homepage "https://www.gnu.org/software/rcs/"
  url "http://ftpmirror.gnu.org/rcs/rcs-5.9.3.tar.xz"
  mirror "https://ftp.gnu.org/gnu/rcs/rcs-5.9.3.tar.xz"
  sha1 "e4a9549678618f5d69968b10c6c9b92b29519813"

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
