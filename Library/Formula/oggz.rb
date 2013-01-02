require 'formula'

class Oggz < Formula
  homepage 'http://www.xiph.org/oggz/'
  url 'http://downloads.xiph.org/releases/liboggz/liboggz-1.1.1.tar.gz'
  sha1 '3540190c8c9a31d834aa7794ef991bbab699f4de'

  depends_on 'pkg-config' => :build
  depends_on 'libogg'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
