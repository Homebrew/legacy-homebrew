require 'formula'

class Cocot <Formula
  homepage 'http://vmi.jp/software/cygwin/cocot.html'
  url 'https://github.com/vmi/cocot/zipball/cocot-1.1-20120313'
  head 'https://github.com/vmi/cocot.git', :branch => 'master'
  version 'cocot-1.1-20120313'
  md5 '2188216d18286bd833b2b116a853c371'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
