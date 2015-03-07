require 'formula'

class Lablgtk < Formula
  homepage 'http://wwwfun.kurims.kyoto-u.ac.jp/soft/lsl/lablgtk.html'
  url 'http://wwwfun.kurims.kyoto-u.ac.jp/soft/lsl/dist/lablgtk-2.14.2.tar.gz'
  sha1 'fd184418ccbc542825748ca63fba75138d2ea561'

  bottle do
    sha1 "f17c4f647c272598eebde8a169be6cdac11e30e5" => :yosemite
    sha1 "298b83442b6f6fd1eefd229ae3820267771b19bc" => :mavericks
    sha1 "d78c6d4a152d142372265af77e9ac95cfb9e92a8" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'camlp4' => :build
  depends_on :x11
  depends_on 'objective-caml'
  depends_on 'gtk+'
  depends_on 'librsvg'

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
