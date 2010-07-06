require 'formula'

class Tintin <Formula
  url 'http://downloads.sourceforge.net/project/tintin/TinTin%2B%2B%20Source%20Code/2.00.1/tintin-2.00.1.tar.gz'
  homepage 'http://tintin.sf.net'
  md5 '5bc8d0f4df124f7fe01a5904084ae01b'

  def install
    Dir.chdir "src"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
