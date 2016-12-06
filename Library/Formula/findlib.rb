require 'formula'

class Findlib < Formula
  homepage 'http://projects.camlcity.org/projects/findlib.html'
  url 'http://download.camlcity.org/download/findlib-1.3.3.tar.gz'
  sha1 '5d1a52b77145348ded29fefe13736694aabb1868'

  depends_on 'objective-caml' => :build

  def install
    system "./configure", "-mandir", "#{man}", "-bindir", "#{bin}",
    			  "-sitelib", "#{lib}/ocaml/site-lib", "-config", "#{etc}"
    system "make all"
    system "make install"
  end

  test do
    system "ocamlfind"
  end
end
