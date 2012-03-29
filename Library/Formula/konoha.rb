require 'formula'

class Konoha < Formula
  homepage 'http://konoha.sourceforge.jp'
  url 'http://sourceforge.jp/frs/redir.php?f=%2Fkonoha%2F43718%2Fkonoha-0.7.1.tar.gz'
  md5 '7f42f227bc251955c653c87cf2051a8a'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
