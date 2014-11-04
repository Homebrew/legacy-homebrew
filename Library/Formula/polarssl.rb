require "formula"

class Polarssl < Formula
  homepage "https://polarssl.org/"
  url "https://polarssl.org/download/polarssl-1.3.9-gpl.tgz"
  # 1.4.0 will need dependents recompiled due to breaking binary compat.
  sha256 "d3605afc28ed4b7d1d9e3142d72e42855e4a23c07c951bbb0299556b02d36755"

  head "https://github.com/polarssl/polarssl.git"

  bottle do
    cellar :any
    sha1 "d265ce8c0677d001ac1e6bf48a1fe979d19a0559" => :yosemite
    sha1 "8715a5351f9a32391e39eab3c5c75b737bff68e6" => :mavericks
    sha1 "f497de9c97371c7e871c7041ccc38f26a7c2847e" => :mountain_lion
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
    # Remove the pointless example application that hooks into system OpenSSL
    rm "#{bin}/o_p_test"
  end
end
