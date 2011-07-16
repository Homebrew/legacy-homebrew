require 'formula'

class Urweb < Formula
  homepage 'http://impredicative.com/ur/'
  url 'http://impredicative.com/ur/urweb-20110715.tgz'
  md5 '69b0f3d3f3ba2e3246b3d61fa8cc4867'
  bottle 'http://hacks.yi.org/~as/machomebrew/urweb-20110715-bottle.tar.gz'
  bottle_sha1 'cb5b4e0d4f121fb8e26bdcb1b88c3c991c8c2191'
  head 'http://hg.impredicative.com/urweb', :using => :hg

  # Binaries only depend on gmp, not mlton. So forgo the mlton install if
  # we're using a bottle
  depends_on 'mlton' if (ARGV.build_from_source? or ARGV.head?)
  depends_on 'gmp'

  def install
    system "aclocal && autoreconf -i --force"
    system "./configure --prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
