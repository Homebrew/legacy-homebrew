require 'formula'

class Libkate < Formula
  homepage 'http://code.google.com/p/libkate/'
  url 'http://libkate.googlecode.com/files/libkate-0.4.1.tar.gz'
  sha1 '87fd8baaddb7120fb4d20b0a0437e44ea8b6c9d8'

  depends_on :libpng
  depends_on 'libogg' => :recommended

  fails_with :gcc do
    build 5666
    cause "Segfault during compilation"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
