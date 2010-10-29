require 'formula'

class Fdupes <Formula
  url 'http://netdial.caribe.net/~adrian2/programs/fdupes-1.40.tar.gz'
  homepage 'http://netdial.caribe.net/~adrian2/fdupes.html'
  md5 '11de9ab4466089b6acbb62816b30b189'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make fdupes"
    system "make install"
  end
end
