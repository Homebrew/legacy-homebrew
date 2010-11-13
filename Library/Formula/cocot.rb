require 'formula'

# cocot - COde COnverter on Tty

class Cocot <Formula
  url 'http://download.github.com/vmi-cocot-1c5e570.tar.gz'
  homepage 'http://vmi.jp/software/cygwin/cocot.html'
  md5 'f08759da35fc90b9319df79cf2f8447e'
  version '20100903'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
