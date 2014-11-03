require "formula"

class Monit < Formula
  homepage "http://mmonit.com/monit/"
  url "http://mmonit.com/monit/dist/monit-5.10.tar.gz"
  sha1 "4933898c6e6191e8d8ee4730c64ef6f16c8130c1"

  bottle do
    cellar :any
    sha1 "cf32163d1a47c0a7b5588890ee4ef1edb32f31a7" => :mavericks
    sha1 "a0ca615a07138b15aa148c3eff51a53ecbf8c562" => :mountain_lion
    sha1 "ab2521e15d9b0d565c058c22db4c2c134fe7239b" => :lion
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit"
    system "make install"
  end

  test do
    system "#{bin}/monit", "-h"
  end
end
