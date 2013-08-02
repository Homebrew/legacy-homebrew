require 'formula'

class GooglePerftools < Formula
  # TODO rename to gperftools when renames are supported
  homepage 'http://code.google.com/p/gperftools/'
  url 'http://gperftools.googlecode.com/files/gperftools-2.1.tar.gz'
  sha1 'b799b99d9f021988bbc931db1c21b2f94826d4f0'

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
