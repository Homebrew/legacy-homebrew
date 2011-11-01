require 'formula'

class Uncrustify < Formula
  url 'http://downloads.sourceforge.net/project/uncrustify/uncrustify/uncrustify-0.59/uncrustify-0.59.tar.gz'
  head 'https://github.com/bengardner/uncrustify.git'
  homepage 'http://uncrustify.sourceforge.net/'
  md5 'ebd8607286073c5234371aa35e085754'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
