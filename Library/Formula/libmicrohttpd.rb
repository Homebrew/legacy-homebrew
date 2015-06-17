class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "http://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.42.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.42.tar.gz"
  sha256 "00352073367003da40607319e4090a6a8308748b59246ae80e9871f34dad7d5b"

  bottle do
    cellar :any
    sha1 "f0da1b25c2538f70f5eb7cae3dc7e6953aca6e8a" => :yosemite
    sha1 "c4dc5f34e12dd865aba4864e33f9aa9c97654fac" => :mavericks
    sha1 "99df120ff4063f1026fc8ebcaecd3d6d96a778f9" => :mountain_lion
  end

  option "with-ssl", "Enable SSL support"
  option :universal

  if build.with? "ssl"
    depends_on "libgcrypt"
    depends_on "gnutls"
  end

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
