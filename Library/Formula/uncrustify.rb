require 'formula'

class Uncrustify < Formula
  url 'http://downloads.sourceforge.net/project/uncrustify/uncrustify/uncrustify-0.59/uncrustify-0.59.tar.gz'
  head 'https://github.com/bengardner/uncrustify.git'
  homepage 'http://uncrustify.sourceforge.net/'
  sha1 '233e4f6cb34ef7020ce49e5b5d14f0d46f277e31'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
