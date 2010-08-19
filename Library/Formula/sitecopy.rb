require 'formula'

class Sitecopy <Formula
  url 'http://www.manyfish.co.uk/sitecopy/sitecopy-0.16.6.tar.gz'
  homepage 'http://www.manyfish.co.uk/sitecopy/'
  md5 'b3aeb5a5f00af3db90b408e8c32a6c01'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libxml2",
                          "--with-ssl"
    system "make install"
  end
end
