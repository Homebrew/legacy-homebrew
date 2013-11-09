require 'formula'

class Liblacewing < Formula
  homepage 'http://lacewing-project.org/'
  head 'https://github.com/udp/lacewing.git'
  url 'https://github.com/udp/lacewing/archive/0.5.4.tar.gz'
  sha1 '078486a4dcd6ce33c2c881954c5dc82843411ac9'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-ssl", "--disable-spdy"
    system "make"
    system "make install"
  end
end
