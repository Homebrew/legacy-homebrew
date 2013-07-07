require 'formula'

class Uncrustify < Formula
  homepage 'http://uncrustify.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/uncrustify/uncrustify/uncrustify-0.60/uncrustify-0.60.tar.gz'
  sha1 '769a7649a1cefb80beff9b67b11b4b87a8cc8e0e'

  head 'https://github.com/bengardner/uncrustify.git'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
