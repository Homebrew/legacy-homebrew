require 'formula'

class Liblacewing < Formula
  homepage 'http://lacewing-project.org/'
  head 'https://github.com/udp/lacewing.git'
  url 'https://github.com/udp/lacewing/archive/0.5.4.tar.gz'
  sha1 '9b355b864f1cff35780e7a9b4c6e9604fdbf9926'

  # Use a newer OpenSSL to get SPDY support
  depends_on 'openssl'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
