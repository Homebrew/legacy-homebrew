require 'formula'

class Fltk < Formula
  homepage 'http://www.fltk.org/'
  url 'http://ftp.easysw.com/pub/fltk/1.3.0/fltk-1.3.0-source.tar.gz'
  md5 '44d5d7ba06afdd36ea17da6b4b703ca3'

  devel do
    url 'http://ftp.easysw.com/pub/fltk/snapshots/fltk-1.3.x-r9327.tar.bz2'
    md5 '3205e5da58069ec7a1e487e6941cccd4'
    version '1.3.x-r9327'
  end

  depends_on :libpng
  depends_on 'jpeg'

  fails_with :clang do
    build 318
    cause "http://llvm.org/bugs/show_bug.cgi?id=10338"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-threads"
    system "make install"
  end
end
