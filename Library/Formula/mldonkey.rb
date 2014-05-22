require 'formula'

class Mldonkey < Formula
  homepage 'http://mldonkey.sourceforge.net/Main_Page'
  url 'https://downloads.sourceforge.net/project/mldonkey/mldonkey/3.1.5/mldonkey-3.1.5.tar.bz2'
  sha1 '7bc4f9272ecfe6403eef7062766b26bf321e3015'

  option "with-x", "Build mldonkey with X11 support"

  depends_on 'pkg-config' => :build
  depends_on 'objective-caml'
  depends_on 'gd'
  depends_on 'libpng'

  if build.with? "x"
    depends_on 'librsvg'
    depends_on 'lablgtk'
  end

  def install
    # Fix compiler selection
    ENV['OCAMLC'] = "#{HOMEBREW_PREFIX}/bin/ocamlc.opt -cc #{ENV.cc}"

    args = ["--prefix=#{prefix}"]
    args << "--enable-gui=newgui2" if build.with? "x"

    system "./configure", *args
    system "make install"
  end
end
