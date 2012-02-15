require 'formula'

class Findlib < Formula
  homepage 'http://projects.camlcity.org/projects/findlib.html'
  url 'http://download.camlcity.org/download/findlib-1.2.7.tar.gz'
  md5 '000bff723e8d3d727a7edd5b5901b540'
  depends_on 'objective-caml'

  def install
    bin.mkpath
    man.mkpath
    lib.mkpath
    (prefix+'etc').mkpath
    system "./configure -bindir #{bin} -mandir #{man} -sitelib #{lib} -with-toolbox"
    system "make all"
    system "make opt"
    system "make install"
  end

  def test
    system "ocamlfind"
  end
end
