require 'formula'

class Libssh2 < Formula
  homepage 'http://www.libssh2.org/'
  url 'http://www.libssh2.org/download/libssh2-1.4.3.tar.gz'
  sha1 'c27ca83e1ffeeac03be98b6eef54448701e044b0'
  revision 1

  bottle do
    cellar :any
    revision 1
    sha1 "77561b594fe158e8ce1d9abf8e4aac2534008438" => :mavericks
    sha1 "09c45c7ad01aba94465be34c390ca6547a92ef88" => :mountain_lion
    sha1 "12f1f78301ce481c34eed2abca5c79d11798dd1d" => :lion
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-openssl",
                          "--with-libssl-prefix=#{Formula['openssl'].opt_prefix}",
                          "--with-libz"
    system "make install"
  end
end
