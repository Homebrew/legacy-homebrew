require 'formula'

class Uncrustify < Formula
  url 'http://downloads.sourceforge.net/project/uncrustify/uncrustify/uncrustify-0.57/uncrustify-0.57.tar.gz'
  head 'git://github.com/bengardner/uncrustify.git'
  homepage 'http://uncrustify.sourceforge.net/'
  md5 'df597bf0380d2a0039023719a9fdb6c5'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
