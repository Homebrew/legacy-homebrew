class Oniguruma < Formula
  homepage "http://www.geocities.jp/kosako3/oniguruma/"
  url "http://www.geocities.jp/kosako3/oniguruma/archive/onig-5.9.6.tar.gz"
  sha1 "08d2d7b64b15cbd024b089f0924037f329bc7246"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
