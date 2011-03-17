require 'formula'

class Re2c < Formula
  url 'http://downloads.sourceforge.net/project/re2c/re2c/0.13.5/re2c-0.13.5.tar.gz'
  homepage 'http://re2c.org'
  md5 '4a97d8f77ed6d2c76c8bd840a43f5633'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
