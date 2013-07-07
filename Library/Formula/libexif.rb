require 'formula'

class Libexif < Formula
  homepage 'http://libexif.sourceforge.net/'
  url 'http://sourceforge.net/projects/libexif/files/libexif/0.6.21/libexif-0.6.21.tar.gz'
  sha1 '4106f02eb5f075da4594769b04c87f59e9f3b931'

  fails_with :llvm do
    build 2334
    cause "segfault with llvm"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
