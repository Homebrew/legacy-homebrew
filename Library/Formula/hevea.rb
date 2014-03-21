require 'formula'

class Hevea < Formula
  homepage 'http://hevea.inria.fr/'
  url 'http://hevea.inria.fr/distri/hevea-2.13.tar.gz'
  sha1 '03b35732f880591743ba750948b14efc0a46578b'

  depends_on 'objective-caml'
  depends_on 'ghostscript' => :optional

  def install
    inreplace 'Makefile', '/usr/local', prefix
    system "make"
    system "make install"
  end
end
