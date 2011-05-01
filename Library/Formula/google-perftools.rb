require 'formula'

class GooglePerftools < Formula
  url 'http://google-perftools.googlecode.com/files/google-perftools-1.7.tar.gz'
  homepage 'http://code.google.com/p/google-perftools/'
  md5 '5839cab3723e68a86ed327ebb54d54bc'

  fails_with_llvm "Segfault during linking", :build => 2326

  def install
    ENV.append_to_cflags '-D_XOPEN_SOURCE'
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
