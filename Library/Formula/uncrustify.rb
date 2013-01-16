require 'formula'

class Uncrustify < Formula
  url 'http://downloads.sourceforge.net/project/uncrustify/uncrustify/uncrustify-0.60/uncrustify-0.60.tar.gz'
  head 'https://github.com/bengardner/uncrustify.git'
  homepage 'http://uncrustify.sourceforge.net/'
  sha1 '769a7649a1cefb80beff9b67b11b4b87a8cc8e0e'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
