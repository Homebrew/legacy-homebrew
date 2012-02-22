require 'formula'

class Libkate < Formula
  homepage 'http://code.google.com/p/libkate/'
  url 'http://libkate.googlecode.com/files/libkate-0.4.1.tar.gz'
  sha1 '87fd8baaddb7120fb4d20b0a0437e44ea8b6c9d8'

  depends_on 'libogg' => :recommended

  def install
    ENV.libpng
    # GCC 4.2 segfaults during compilation
    # FIXME when we can do fails_with :gcc
    ENV.llvm if ENV.compiler == :gcc

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
