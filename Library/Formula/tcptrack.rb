require 'formula'

class Tcptrack <Formula
  url 'http://www.rhythm.cx/~steve/devel/tcptrack/release/1.3.0/source/tcptrack-1.3.0.tar.gz'
  homepage 'http://www.rhythm.cx/~steve/devel/tcptrack/'
  md5 '227baeb2f96758f7614f6f788b6a4d93'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

  def caveats
    "Run tcptrack as root or via sudo in order for the program to obtain permissions on the network interface."
  end
end
