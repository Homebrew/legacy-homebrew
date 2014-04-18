require 'formula'

class Libunistring < Formula
  homepage 'http://www.gnu.org/software/libunistring/'
  url 'http://ftpmirror.gnu.org/libunistring/libunistring-0.9.3.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libunistring/libunistring-0.9.3.tar.gz'
  sha1 'e1ea13c24a30bc93932d19eb5ad0704a618506dd'

  bottle do
    cellar :any
    sha1 "fd93c4c18b2b526b77d9dfeefd11ff89a6effc02" => :mavericks
    sha1 "4bbf7ca720de8b13e2ebac7b5bb88ef2057b21a4" => :mountain_lion
    sha1 "ed2d278f23e772a0401897a579deff47606b5d03" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
