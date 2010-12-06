require 'formula'

class Libdshconfig <Formula
  url 'http://www.netfort.gr.jp/~dancer/software/downloads/libdshconfig-0.20.9.tar.gz'
  homepage 'http://www.netfort.gr.jp/~dancer/software/downloads/list.cgi#libdshconfig'
  md5 'c3fabfae1782c17ee989373c2f6a73c1'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make && make install"
  end
end
