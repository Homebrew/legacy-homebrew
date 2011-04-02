require 'formula'

class GooglePerftools < Formula
  url 'http://google-perftools.googlecode.com/files/google-perftools-1.6.tar.gz'
  homepage 'http://code.google.com/p/google-perftools/'
  md5 '7acfee8d3e2ba968d20684e9f7033015'

  fails_with_llvm "Segfault during linking", :build => 2326

  def install
    ENV.append_to_cflags '-D_XOPEN_SOURCE'
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
