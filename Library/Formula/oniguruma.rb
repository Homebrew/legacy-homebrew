require 'formula'

class Oniguruma < Formula
  url 'http://www.geocities.jp/kosako3/oniguruma/archive/onig-5.9.2.tar.gz'
  homepage 'http://www.geocities.jp/kosako3/oniguruma/'
  md5 '0f4ad1b100a5f9a91623e04111707b84'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
