require 'formula'

class Bloom <Formula
  url 'http://afflib.org/downloads/bloom-1.4.1.tar.gz'
  homepage 'http://afflib.org/'
  md5 'fb2c6231b6f145b9f3dd8b3fb322a413'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
