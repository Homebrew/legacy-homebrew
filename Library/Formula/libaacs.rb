require "formula"

class Libaacs < Formula
  homepage "https://www.videolan.org/developers/libaacs.html"
  url "ftp://ftp.videolan.org/pub/videolan/libaacs/0.7.1/libaacs-0.7.1.tar.bz2"
  mirror "http://videolan-nyc.defaultroute.com/libaacs/0.7.1/libaacs-0.7.1.tar.bz2"
  sha1 "09eb61bcfceca77cd779c4475093dd22a0cb5510"

  bottle do
    cellar :any
    sha1 "9ac7056e5857137d57d42d41a4743e5a6444e66f" => :mavericks
    sha1 "aec8c5c4c2c3421522000a1fc6e0c550a7d2dd7b" => :mountain_lion
    sha1 "8907c7d984959ea8a3f5b83134ce8fe19c0fa314" => :lion
  end

  head do
    url "git://git.videolan.org/libaacs.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "bison" => :build
  depends_on "libgcrypt"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
