require 'brewkit'

class Most <Formula
  @url='ftp://space.mit.edu/pub/davis/most/most-5.0.0.tar.gz'
  @homepage='http://www.jedsoft.org/most/'
  @md5='8352a6c5b31363f3e60e02a523d6784a'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
