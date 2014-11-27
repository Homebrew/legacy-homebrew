require "formula"

class Libmicrohttpd < Formula
  homepage "http://www.gnu.org/software/libmicrohttpd/"
  url "http://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.38.tar.gz"
  mirror "http://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.38.tar.gz"
  sha1 "1d0a6685b984b022a6be565f7b179c449944b3f1"

  option "with-ssl", "Enable SSL support"

  if build.with? "ssl"
    depends_on "libgcrypt"
    depends_on "gnutls"
  end

  bottle do
    cellar :any
    sha1 "f0da1b25c2538f70f5eb7cae3dc7e6953aca6e8a" => :yosemite
    sha1 "c4dc5f34e12dd865aba4864e33f9aa9c97654fac" => :mavericks
    sha1 "99df120ff4063f1026fc8ebcaecd3d6d96a778f9" => :mountain_lion
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
