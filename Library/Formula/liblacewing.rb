require 'formula'

class Liblacewing < Formula
  homepage 'http://lacewing-project.org/'
  head 'https://github.com/udp/lacewing.git'
  url 'https://github.com/udp/lacewing/archive/0.5.3.tar.gz'
  sha1 'dd408716ef14630ef6636aa47dd1150c44615e8d'

  # Use a newer OpenSSL to get SPDY support
  depends_on 'openssl'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
