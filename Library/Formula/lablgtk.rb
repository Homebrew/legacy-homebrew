require 'formula'

class Lablgtk < Formula
  homepage 'http://wwwfun.kurims.kyoto-u.ac.jp/soft/lsl/lablgtk.html'
  url 'http://wwwfun.kurims.kyoto-u.ac.jp/soft/lsl/dist/lablgtk-2.14.2.tar.gz'
  sha1 'fd184418ccbc542825748ca63fba75138d2ea561'

  depends_on 'pkg-config' => :build
  depends_on :x11
  depends_on 'objective-caml'
  depends_on 'gtk+'

  def install
    system "./configure", "--bindir=#{bin}",
                          "--libdir=#{lib}",
                          "--mandir=#{man}",
                          "--with-libdir=#{lib}/ocaml"
    ENV.j1
    system "make world"
    system "make install"
  end
end
