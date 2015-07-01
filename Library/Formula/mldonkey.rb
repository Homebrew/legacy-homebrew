require 'formula'

class Mldonkey < Formula
  desc "OCaml/GTK client for the eDonkey P2P network"
  homepage 'http://mldonkey.sourceforge.net/Main_Page'
  url 'https://downloads.sourceforge.net/project/mldonkey/mldonkey/3.1.5/mldonkey-3.1.5.tar.bz2'
  sha256 '74f9d4bcc72356aa28d0812767ef5b9daa03efc5d1ddabf56447dc04969911cb'

  # Fix a comment that causes an error in recent ocaml;
  # fixed upstream, will be in the next release.
  patch do
    url "https://github.com/ygrek/mldonkey/commit/c91a78896526640a301f5a9eeab8b698923e285c.patch"
    sha256 "1fb503d37eed92390eb891878a9e6d69b778bd2f1d40b9845d18aa3002f3d739"
  end

  deprecated_option "with-x" => "with-x11"

  depends_on 'pkg-config' => :build
  depends_on 'objective-caml'
  depends_on 'camlp4'
  depends_on 'gd'
  depends_on 'libpng'
  depends_on :x11 => :optional

  if build.with? "x11"
    depends_on 'librsvg'
    depends_on 'lablgtk'
  end

  def install
    ENV.j1

    # Fix compiler selection
    ENV['OCAMLC'] = "#{HOMEBREW_PREFIX}/bin/ocamlc.opt -cc #{ENV.cc}"

    args = ["--prefix=#{prefix}"]
    args << "--enable-gui=newgui2" if build.with? "x11"

    system "./configure", *args
    system "make install"
  end
end
