require 'formula'

class Hevea < Formula
  homepage 'http://hevea.inria.fr/'
  url "http://hevea.inria.fr/distri/hevea-2.14.tar.gz"
  sha1 "78152c83802e34881ce3414072d75bff66facb15"

  bottle do
  end

  depends_on 'objective-caml'
  depends_on 'ghostscript' => :optional

  def install
    inreplace 'Makefile', '/usr/local', prefix
    system "make"
    system "make install"
  end
end
