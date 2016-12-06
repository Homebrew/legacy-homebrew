require 'formula'

class Fuse4x < Formula
  homepage 'http://fuse4x.org/'
  url 'https://github.com/fuse4x/fuse.git', :tag => "fuse4x_0_8_11"
  version "0.8.11"

  depends_on 'gettext'
  depends_on 'fuse4x-kext'

  def install
    gettext = Formula.factory('gettext')

    ENV['ACLOCAL'] = "/usr/bin/aclocal -I#{gettext.share}/aclocal"

    system "autoreconf", "--force", "--install"
    system "./configure", "--disable-dependency-tracking", "--disable-debug", "--disable-static", "--prefix=#{prefix}"
    system "make install"
  end
end
