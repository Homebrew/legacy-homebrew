require 'formula'

class Uncrustify < Formula
  url 'http://downloads.sourceforge.net/project/uncrustify/uncrustify/uncrustify-0.58/uncrustify-0.58.tar.gz'
  head 'https://github.com/bengardner/uncrustify.git'
  homepage 'http://uncrustify.sourceforge.net/'
  md5 '9fa275570a4422aa1cb90fbbdde79a76'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
