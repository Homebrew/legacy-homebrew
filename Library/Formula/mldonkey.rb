require 'formula'

class Mldonkey < Formula
  homepage 'http://mldonkey.sourceforge.net/Main_Page'
  url 'http://downloads.sourceforge.net/project/mldonkey/mldonkey/3.1.1/mldonkey-3.1.1.tar.bz2'
  sha1 '2d0bc9f849728528f833e32db3b051aab51b6c7f'

  depends_on 'objective-caml'

  if ARGV.include? "--with-x"
    depends_on 'librsvg'
    depends_on 'lablgtk'
  end

  def options
    [["--with-x", "Build mldonkey with X11 support"]]
  end

  def install
    ENV.libpng

    # Fix compiler selection
    ENV['OCAMLC'] = "#{HOMEBREW_PREFIX}/bin/ocamlc.opt -cc #{ENV.cc}"
    inreplace 'Makefile', '-O6', '' if ENV.compiler == :clang

    args = ["--prefix=#{prefix}"]
    args << "--enable-gui=newgui2" if ARGV.include? "--with-x"

    system "./configure", *args
    system "make install"
  end
end
