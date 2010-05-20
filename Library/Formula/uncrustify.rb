require 'formula'

class Uncrustify <Formula
  url 'http://downloads.sourceforge.net/project/uncrustify/uncrustify/uncrustify-0.56/uncrustify-0.56.tar.gz'
  head 'git://github.com/bengardner/uncrustify.git'
  homepage 'http://uncrustify.sourceforge.net/'
  md5 '991ee882a265fa28f23f747737bce740'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
