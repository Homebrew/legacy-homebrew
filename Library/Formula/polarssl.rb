require "formula"

class Polarssl < Formula
  homepage "https://polarssl.org/"
  url "https://polarssl.org/download/polarssl-1.3.8-gpl.tgz"
  mirror "https://mirrors.kernel.org/debian/pool/main/p/polarssl/polarssl_1.3.8.orig.tar.gz"
  sha256 "318171db41335cacbb5b0047c94f1faf91442ab70a223b5223436703c9406ff1"
  revision 1

  head "https://github.com/polarssl/polarssl.git"

  bottle do
    cellar :any
    sha1 "2a9781da8005829215bb509bcece0168e272ce09" => :yosemite
    sha1 "9f497c6ccb15dc4ee778ec288e8adc0eee0aa589" => :mavericks
    sha1 "6c281878c95e323f7659f18d20990f474a6036a9" => :mountain_lion
  end

  depends_on "cmake" => :build

  conflicts_with "md5sha1sum", :because => "both install conflicting binaries"

  def install
  # Kills SSL2 Handshake & SSLv3 using upstream's recommended method.
  # Upstream, can you make this less hacky please?
  inreplace "include/polarssl/config.h" do |s|
    s.gsub! "#define POLARSSL_SSL_SRV_SUPPORT_SSLV2_CLIENT_HELLO", "//#define POLARSSL_SSL_SRV_SUPPORT_SSLV2_CLIENT_HELLO"
    s.gsub! "#define POLARSSL_SSL_PROTO_SSL3", "//#define POLARSSL_SSL_PROTO_SSL3"
  end

    system "cmake", ".",  *std_cmake_args
    system "make"
    system "make", "install"
    # Why does PolarSSL ship with GNU's Hello included? Let's remove that.
    rm "#{bin}/hello"
  end
end
