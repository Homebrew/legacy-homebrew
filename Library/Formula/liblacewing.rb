require 'formula'

class Liblacewing < Formula
  homepage 'http://lacewing-project.org/'
  head 'https://github.com/udp/lacewing.git'
  url 'https://github.com/udp/lacewing/archive/0.5.3.tar.gz'
  sha1 'ce94a6b5228d6af46eb54ecd669bb56f4f56407a'

  # Use a newer OpenSSL to get SPDY support
  depends_on 'openssl'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
