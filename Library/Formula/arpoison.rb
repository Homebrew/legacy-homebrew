require 'formula'

class Arpoison <Formula
  url 'http://www.arpoison.net/arpoison-0.6.tar.gz'
  homepage 'http://www.arpoison.net/'
  md5 '5274ae9c7c879b97b425a4b2da59aa65'

  depends_on 'libnet'

  def install
    system "make"
    system "mkdir #{prefix}/bin"
    system "install arpoison #{prefix}/bin"
  end
end
