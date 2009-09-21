require 'brewkit'

class Redland <Formula
  @url='http://download.librdf.org/source/redland-1.0.9.tar.gz'
  @homepage='http://librdf.org/'
  @md5='e5ef0c29c55b4f0f5aeed7955b4d383b'

  depends_on 'raptor'
  depends_on 'rasqal'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
