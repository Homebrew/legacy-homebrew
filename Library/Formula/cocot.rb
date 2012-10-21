require 'formula'

class Cocot < Formula
  homepage 'http://vmi.jp/software/cygwin/cocot.html'
  url 'https://github.com/vmi/cocot/tarball/cocot-1.1-20120313'
  version '1.1-20120313'
  sha1 '66dde7a784addd9aadd8223af6e677ff0d56ac49'
  head 'https://github.com/vmi/cocot.git', :branch => 'master'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
