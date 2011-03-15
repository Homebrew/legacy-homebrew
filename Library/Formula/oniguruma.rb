require 'formula'

class Oniguruma < Formula
  url 'http://www.geocities.jp/kosako3/oniguruma/archive/onig-5.9.1.tar.gz'
  homepage 'http://www.geocities.jp/kosako3/oniguruma/'
  md5 '5ce5f9bba5e83f0ea6ec24e1ac77091c'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
