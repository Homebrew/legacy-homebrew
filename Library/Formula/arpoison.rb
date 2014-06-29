require 'formula'

class Arpoison < Formula
  homepage 'http://www.arpoison.net/'
  url 'http://www.arpoison.net/arpoison-0.7.tar.gz'
  sha1 '14e89b1acbd09874fd389b3cef0dd1a7c7f253ae'

  depends_on 'libnet'

  def install
    system "make"
    bin.install "arpoison"
  end
end
