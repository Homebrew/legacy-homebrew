require 'formula'

class Arpoison < Formula
  homepage 'http://www.arpoison.net/'
  url 'http://www.arpoison.net/arpoison-0.6.tar.gz'
  sha1 'a4adc83fd0a29776f8135f304e5b090b5bf31b56'

  depends_on 'libnet'

  def install
    system "make"
    bin.install "arpoison"
  end
end
