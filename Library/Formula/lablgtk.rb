require 'formula'

class Lablgtk <Formula
  url 'http://wwwfun.kurims.kyoto-u.ac.jp/soft/lsl/dist/lablgtk-2.14.2.tar.gz'
  homepage 'http://wwwfun.kurims.kyoto-u.ac.jp/soft/lsl/lablgtk.html'
  md5 'bad77680a72dab8b915cae99d1ec9b1f'

  depends_on 'objective-caml'
  depends_on 'gtk+'

  def install
    system "./configure", "--bindir=#{bin}", "--libdir=#{lib}", "--mandir=#{man}"
    system "make world"
    ENV.j1
    system "make install"
  end
end
