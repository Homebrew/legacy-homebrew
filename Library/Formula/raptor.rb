require 'brewkit'

class Raptor <Formula
  @url='http://download.librdf.org/source/raptor-1.4.19.tar.gz'
  @homepage='http://librdf.org/raptor/'
  @md5='50acbd3b416c3f9e1a3a8ddb825bac25'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
