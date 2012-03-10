require 'formula'

class GooglePerftools < Formula
  url 'http://google-perftools.googlecode.com/files/google-perftools-1.8.tar.gz'
  homepage 'http://code.google.com/p/google-perftools/'
  sha1 '9490214967913bd579201a60a25320e316d731a5'

  fails_with_llvm "Segfault during linking", :build => 2326

  def install
    ENV.append_to_cflags '-D_XOPEN_SOURCE'
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
