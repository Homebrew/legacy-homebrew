class Libmicrohttpd < Formula
  desc "Light HTTP/1.1 server library"
  homepage "https://www.gnu.org/software/libmicrohttpd/"
  url "http://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-0.9.47.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.47.tar.gz"
  sha256 "96bdab4352a09fd3952a346bc01898536992f50127d0adea1c3096a8ec9f658c"
  revision 1

  bottle do
    cellar :any
    sha256 "93c8f51521bcf53845a45e9b4b6d3e3ed75e8139e6fd2ebb9746d81e7f897a60" => :el_capitan
    sha256 "5e7745e96d525f853d1ddbe1665ed7245283b88ae17d51e019c8dc4319071f17" => :yosemite
    sha256 "45bb84451daa9e020cc81e8b17f8a461ce0f972735d583a2d366b9b7d468544d" => :mavericks
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
