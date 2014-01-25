require 'formula'

class Hevea < Formula
  homepage 'http://hevea.inria.fr/'
  url 'http://hevea.inria.fr/distri/hevea-2.12.tar.gz'
  sha1 '21ca8c366a3fd1030b3cfba3cd2aa16e6baf5c56'

  depends_on 'objective-caml'
  depends_on 'ghostscript' => :optional

  def install
    inreplace 'Makefile', '/usr/local', prefix
    system "make"
    system "make install"
  end
end
