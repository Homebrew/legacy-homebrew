require 'formula'

class Gqlplus < Formula
  homepage 'http://gqlplus.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/gqlplus/gqlplus/1.15/gqlplus-1.15.tar.gz'
  sha1 '6ae3ecda0259656d6001ce5d9f956067aa720dec'

  depends_on 'readline'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    bin.install "gqlplus"
  end
end
