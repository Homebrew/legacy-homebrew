require 'formula'

class Mldonkey < Formula
  homepage 'http://mldonkey.sourceforge.net/Main_Page'
  url 'http://downloads.sourceforge.net/project/mldonkey/mldonkey/3.1.3/mldonkey-3.1.3.tar.bz2'
  sha1 '424386f277e84df55a2cbab213fae60787e42c8b'

  option "with-x", "Build mldonkey with X11 support"

  depends_on 'objective-caml'
  depends_on :libpng

  if build.include? "with-x"
    depends_on 'librsvg'
    depends_on 'lablgtk'
  end

  def install
    # Fix compiler selection
    ENV['OCAMLC'] = "#{HOMEBREW_PREFIX}/bin/ocamlc.opt -cc #{ENV.cc}"

    args = ["--prefix=#{prefix}"]
    args << "--enable-gui=newgui2" if build.include? "with-x"

    system "./configure", *args
    system "make install"
  end
end
