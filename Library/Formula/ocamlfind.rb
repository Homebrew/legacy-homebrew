require 'formula'

class Ocamlfind < Formula
  url 'http://download.camlcity.org/download/findlib-1.2.7.tar.gz'
  homepage 'http://projects.camlcity.org/projects/findlib.html'
  md5 '000bff723e8d3d727a7edd5b5901b540'
  depends_on "objective-caml"

  def install
    system "mkdir -p #{bin}"
    system "mkdir -p #{man}"
    system "mkdir -p #{lib}"
    system "mkdir -p #{prefix}/etc"
    system "./configure -bindir #{bin} -mandir #{man} -sitelib #{lib} -config #{prefix}/etc -with-toolbox"
    system "make all"
    system "make opt"
    system "make install"
  end

  def test
    system "ocamlfind"
  end
end
