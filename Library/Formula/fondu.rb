require 'formula'

class Fondu < Formula
  homepage 'http://fondu.sourceforge.net/'
  url 'http://fondu.sourceforge.net/fondu_src-060102.tgz'
  sha1 '4fa5438df935f15f0370802f94a04e8d1263061b'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    bin.install 'fondu', 'ufond'
    man1.install 'fondu.1', 'ufond.1'
  end
end
