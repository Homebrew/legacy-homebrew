require 'formula'

class Twolame < Formula
  homepage 'http://www.twolame.org/'
  url 'http://downloads.sourceforge.net/twolame/twolame-0.3.13.tar.gz'
  md5 '4113d8aa80194459b45b83d4dbde8ddb'

  depends_on 'pkg-config' => :build
  depends_on 'libsndfile'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
