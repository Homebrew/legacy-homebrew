require 'formula'

class Cocot < Formula
  homepage 'http://vmi.jp/software/cygwin/cocot.html'
  url 'https://github.com/vmi/cocot/tarball/cocot-1.1-20120313'
  version '1.1-20120313'
  md5 '666c1e52c1648094f8758689ad3f6b4b'
  head 'https://github.com/vmi/cocot.git', :branch => 'master'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
