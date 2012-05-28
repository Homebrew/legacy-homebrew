require 'formula'

class Abiword < Formula
  homepage 'http://www.abisource.com/'
  url 'http://www.abisource.com/downloads/abiword/2.8.6/source/abiword-2.8.6.tar.gz'
  md5 'f883b0a7f26229a9c66fd6a1a94381aa'

  devel do
    url 'http://www.abisource.com/downloads/abiword/2.9.2/source/abiword-2.9.2.tar.gz'
    sha1 '34a6e4e9c5619e8f2d619ac844519fc9378405b3'
  end

  depends_on 'jpeg'
  depends_on 'fribidi'
  depends_on 'libgsf'
  depends_on 'enchant'
  depends_on 'cairo'
  depends_on 'pango'
  depends_on 'wv'
  depends_on 'imagemagick'

  def install
    ENV.libpng
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
