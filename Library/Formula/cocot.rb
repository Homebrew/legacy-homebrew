require 'formula'

class Cocot <Formula
  homepage 'http://vmi.jp/software/cygwin/cocot.html'
  url 'git://github.com/vmi/cocot.git', :tag => 'cocot-1.0-20100903'
  head 'git://github.com/vmi/cocot.git', :branch => 'master'
  version 'cocot-1.0-20100903'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
