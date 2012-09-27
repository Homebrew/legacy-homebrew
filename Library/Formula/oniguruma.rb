require 'formula'

class Oniguruma < Formula
  url 'http://www.geocities.jp/kosako3/oniguruma/archive/onig-5.9.2.tar.gz'
  homepage 'http://www.geocities.jp/kosako3/oniguruma/'
  sha1 '63d0a412b9e8578724c37ef8936704c8b985f6cb'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
