require 'formula'

class Kelbt < Formula
  url 'http://www.complang.org/kelbt/kelbt-0.14.tar.gz'
  homepage 'http://www.complang.org/kelbt/'
  md5 '6eeaaa79e665389d7953361d10815fb5'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
