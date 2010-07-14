require 'formula'

class Hevea <Formula
  url 'http://hevea.inria.fr/distri/hevea-1.10.tar.gz'
  homepage 'http://hevea.inria.fr/'
  md5 '24a631570bee3cc4b8350e9db39be62b'

  depends_on 'objective-caml'
  depends_on 'ghostscript' => :optional 

  def install
    inreplace 'Makefile', '/usr/local', "#{prefix}"
    system "make"
    system "make install"
  end
end
