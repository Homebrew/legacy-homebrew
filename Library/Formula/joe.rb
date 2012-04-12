require 'formula'

class Joe < Formula
  url 'http://downloads.sourceforge.net/project/joe-editor/JOE%20sources/joe-3.7/joe-3.7.tar.gz'
  homepage 'http://joe-editor.sourceforge.net/index.html'
  md5 '66de1b073e869ba12abbfcde3885c577'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
