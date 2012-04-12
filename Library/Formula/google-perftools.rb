require 'formula'

class GooglePerftools < Formula
  url 'http://google-perftools.googlecode.com/files/google-perftools-1.8.tar.gz'
  homepage 'http://code.google.com/p/google-perftools/'
  sha1 '9490214967913bd579201a60a25320e316d731a5'

  fails_with :llvm do
    build 2326
    cause "Segfault during linking"
  end

  def install
    ENV.append_to_cflags '-D_XOPEN_SOURCE'
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
