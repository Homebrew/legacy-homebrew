require 'formula'

class Socat < Formula
  homepage 'http://www.dest-unreach.org/socat/'
  url 'http://www.dest-unreach.org/socat/download/socat-1.7.2.4.tar.bz2'
  mirror 'http://ftp.de.debian.org/debian/pool/main/s/socat/socat_1.7.2.4.orig.tar.bz2'
  sha1 '55650f3c4c1a5cdc323b2e6eece416b6303d39b5'
  revision 1

  bottle do
    cellar :any
    revision 1
    sha1 "5ffec90f5f7c1c515cf131364981ff7737b9551a" => :mavericks
    sha1 "029fb4d33ebd3f5afae75b5da5cb6de72c19a2c3" => :mountain_lion
    sha1 "06edff14216361eebb2a348b0a51954a12dc3f60" => :lion
  end

  depends_on 'readline'
  depends_on 'openssl'

  def install
    ENV.enable_warnings # -w causes build to fail
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
