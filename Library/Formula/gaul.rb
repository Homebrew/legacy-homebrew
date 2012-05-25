require 'formula'

class Gaul < Formula
  homepage 'http://gaul.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/gaul/gaul-devel/0.1850-0/gaul-devel-0.1850-0.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fgaul%2Ffiles%2F&ts=1337947631'
  md5 '3a832c882b0df0f5c46f733d360fd7bb'
  version '0.1850-0'

  depends_on 's-lang'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "false"
  end
end
