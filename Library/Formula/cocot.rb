require 'formula'

class Cocot <Formula
  head 'git://github.com/vmi/cocot.git', :branch => 'master'
  homepage 'http://vmi.jp/software/cygwin/cocot.html'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
