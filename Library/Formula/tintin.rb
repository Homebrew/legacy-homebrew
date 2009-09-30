require 'brewkit'

class Tintin <Formula
  url 'http://downloads.sourceforge.net/project/tintin/TinTin%2B%2B%20Source%20Code/1.99.7/tintin-1.99.7.tar.gz'
  homepage 'http://tintin.sf.net'
  md5 '397769453038db1697e460fe24218d7d'

  def install
    Dir.chdir "src"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
