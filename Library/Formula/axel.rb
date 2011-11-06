require 'formula'

class Axel < Formula
  url 'http://alioth.debian.org/frs/download.php/3016/axel-2.4.tar.bz2'
  homepage 'http://freshmeat.net/projects/axel/'
  md5 '5fd72e67a682d20874b9f6d073201c6a'

  def install
    system "./configure", "--prefix=#{prefix}", "--debug=0", "--i18n=0"
    system "make"
    system "make install"
  end
end
