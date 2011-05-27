require 'formula'

class GooglePerftools < Formula
  url 'http://google-perftools.googlecode.com/files/google-perftools-1.7.tar.gz'
  homepage 'http://code.google.com/p/google-perftools/'
  sha1 'e3a65f71aee9270572f7aafa421858e39da1a9a8'

  fails_with_llvm "Segfault during linking", :build => 2326

  def install
    ENV.append_to_cflags '-D_XOPEN_SOURCE'
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
