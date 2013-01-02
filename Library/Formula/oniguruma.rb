require 'formula'

class Oniguruma < Formula
  url 'http://www.geocities.jp/kosako3/oniguruma/archive/onig-5.9.3.tar.gz'
  homepage 'http://www.geocities.jp/kosako3/oniguruma/'
  sha1 '235e0ec46582e4dbd12c44aeba97d1219aed6702'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
