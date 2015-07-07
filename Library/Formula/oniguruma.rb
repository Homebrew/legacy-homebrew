class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "http://www.geocities.jp/kosako3/oniguruma/"
  url "http://www.geocities.jp/kosako3/oniguruma/archive/onig-5.9.6.tar.gz"
  sha1 "08d2d7b64b15cbd024b089f0924037f329bc7246"

  bottle do
    cellar :any
    sha1 "12f394ce6f8694efa03d1a7ce2d18fc9a069a75c" => :yosemite
    sha1 "5243422d56451c96768528739932c5651e7a10d7" => :mavericks
    sha1 "62ca1e24ca20cecb83b8cbeeaf1335b94faffe4b" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
