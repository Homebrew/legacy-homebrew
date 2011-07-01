require 'formula'

class Fribidi < Formula
  url 'http://fribidi.org/download/fribidi-0.10.9.tar.gz'
  md5 '647aee89079b056269ff0918dc1c6d28'
  homepage 'http://fribidi.org/'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
